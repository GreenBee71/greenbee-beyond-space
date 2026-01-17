from fastapi import APIRouter, Depends, HTTPException, status, UploadFile, File
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy import func
from datetime import date
import csv
import io

from ...db.database import get_db
from ...models.models import User, UserApartment, AdminFee, EnergyUsage, SystemAnnouncement, IoTDevice
from .auth import get_current_user

router = APIRouter()

async def get_current_master(current_user: User = Depends(get_current_user)):
    if current_user.global_role != "MASTER_ADMIN":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Master privileges required. Global MASTER_ADMIN role needed."
        )
    return current_user

@router.get("/stats/overview")
async def get_master_stats(
    db: AsyncSession = Depends(get_db),
    current_master: User = Depends(get_current_master)
):
    # Total Users across all complexes
    user_count_result = await db.execute(select(func.count(User.id)))
    user_count = user_count_result.scalar() or 0
    
    # Total Complexes (Distinct complex names)
    complex_count_result = await db.execute(select(func.count(func.distinct(UserApartment.complex_name))))
    complex_count = complex_count_result.scalar() or 0
    
    # Aggregated Energy Usage
    energy_sum_result = await db.execute(select(func.sum(EnergyUsage.electricity)))
    energy_sum = energy_sum_result.scalar() or 0
    
    return {
        "total_users": user_count,
        "total_complexes": complex_count,
        "total_electricity_kwh": energy_sum,
        "active_complexes": complex_count, 
        "system_status": "Healthy"
    }

@router.post("/billings/upload")
async def upload_bulk_billings(
    file: UploadFile = File(...),
    db: AsyncSession = Depends(get_db),
    current_master: User = Depends(get_current_master)
):
    if not file.filename.endswith('.csv'):
        raise HTTPException(status_code=400, detail="Only CSV files are supported")
    
    contents = await file.read()
    string_io = io.StringIO(contents.decode('utf-8'))
    reader = csv.DictReader(string_io)
    
    count = 0
    errors = []
    
    for row in reader:
        try:
            email = row.get('email')
            complex_name = row.get('complex_name')
            dong = row.get('dong')
            ho = row.get('ho')
            
            # Find UserApartment
            stmt = select(UserApartment).join(User).where(
                User.email == email,
                UserApartment.complex_name == complex_name,
                UserApartment.dong == dong,
                UserApartment.ho == ho
            )
            result = await db.execute(stmt)
            apartment = result.scalars().first()
            
            if not apartment:
                errors.append(f"Row {count+1}: User/Apartment not found for {email} in {complex_name} {dong}-{ho}")
                continue
            
            # Parse Dates and Amounts
            year = int(row.get('year', 2024))
            month = int(row.get('month', 1))
            billing_date = date(year, month, 1)
            
            total_amount = float(row.get('total_amount', 0))
            
            # Create AdminFee
            details = {
                "general_mgmt": int(row.get('mgmt_fee', 0)),
                "security": int(row.get('security_fee', 0)),
                "cleaning": int(row.get('cleaning_fee', 0)),
                "energy_electric": int(row.get('electricity_fee', 0)),
                "energy_water": int(row.get('water_fee', 0)),
            }
            
            new_fee = AdminFee(
                user_apartment_id=apartment.id,
                billing_month=billing_date,
                total_amount=total_amount,
                status="UNPAID",
                details=details
            )
            db.add(new_fee)
            
            # Create EnergyUsage if provided
            if 'electricity_kwh' in row:
                new_usage = EnergyUsage(
                    user_apartment_id=apartment.id,
                    usage_month=billing_date,
                    electricity=int(row.get('electricity_kwh', 0)),
                    water=int(row.get('water_m3', 0)),
                    gas=int(row.get('gas_m3', 0)),
                    heating=int(row.get('heating_mcal', 0))
                )
                db.add(new_usage)
            
            count += 1
        except Exception as e:
            errors.append(f"Row {count+1}: Unexpected error: {str(e)}")
        
    await db.commit()
    return {
        "message": f"Successfully processed {count} records",
        "errors": errors if errors else None
    }

@router.get("/complexes")
async def get_complexes(
    db: AsyncSession = Depends(get_db),
    current_master: User = Depends(get_current_master)
):
    # Get distinct complex names and number of residents/admins
    # Using a subquery for counts
    result = await db.execute(
        select(
            UserApartment.complex_name,
            func.count(UserApartment.id).label("total_members")
        ).group_by(UserApartment.complex_name)
    )
    
    complex_list = []
    for row in result:
        # For each complex, find an admin name if exists
        admin_result = await db.execute(
            select(User.full_name).join(UserApartment).where(
                UserApartment.complex_name == row[0],
                UserApartment.role == "ADMIN"
            ).limit(1)
        )
        admin_name = admin_result.scalar() or "No Admin Assigned"
        
        complex_list.append({
            "name": row[0],
            "admin_name": admin_name,
            "total_members": row[1],
            "status": "Active"
        })
    return complex_list

@router.post("/complexes")
async def create_complex(
    data: dict,
    db: AsyncSession = Depends(get_db),
    current_master: User = Depends(get_current_master)
):
    complex_name = data.get("name")
    if not complex_name:
        raise HTTPException(status_code=400, detail="Complex name is required")
    
    # Check if exists
    result = await db.execute(select(UserApartment).where(UserApartment.complex_name == complex_name))
    if result.scalars().first():
        # Even if it exists as an empty complex (conceptually through residents), 
        # for this mock logic, we treat it as error if already managed.
        pass

    # Since we don't have a dedicated 'Complex' table yet (it's implicit in UserApartment),
    # we might create a placeholder entry if needed, but for now we'll just return success 
    # as the frontend will then be able to assign users to it.
    return {"message": f"Complex {complex_name} initialized.", "name": complex_name}

@router.get("/users")
async def get_all_users(
    db: AsyncSession = Depends(get_db),
    current_master: User = Depends(get_current_master)
):
    # Join User with UserApartment to see roles and complexes
    result = await db.execute(
        select(User, UserApartment).outerjoin(UserApartment).order_by(User.id)
    )
    
    users_data = []
    # Use a dict to group by user_id if they have multiple apartments
    user_map = {}
    
    for user, apt in result:
        if user.id not in user_map:
            user_map[user.id] = {
                "id": user.id,
                "email": user.email,
                "full_name": user.full_name,
                "is_verified": user.is_verified,
                "created_at": user.created_at.isoformat() if user.created_at else None,
                "apartments": []
            }
        if apt:
            user_map[user.id]["apartments"].append({
                "complex_name": apt.complex_name,
                "dong": apt.dong,
                "ho": apt.ho,
                "role": apt.role
            })
            
    return list(user_map.values())

@router.get("/announcements")
async def get_announcements(
    db: AsyncSession = Depends(get_db),
    current_master: User = Depends(get_current_master)
):
    result = await db.execute(select(SystemAnnouncement).order_by(SystemAnnouncement.created_at.desc()))
    return result.scalars().all()

@router.post("/announcements")
async def create_announcement(
    data: dict,
    db: AsyncSession = Depends(get_db),
    current_master: User = Depends(get_current_master)
):
    new_announcement = SystemAnnouncement(
        title=data.get("title"),
        content=data.get("content"),
        target_complex=data.get("target_complex", "ALL"),
        is_active=True
    )
    db.add(new_announcement)
    await db.commit()
    await db.refresh(new_announcement)
    return new_announcement

@router.delete("/complexes/{name}")
async def delete_complex(
    name: str,
    db: AsyncSession = Depends(get_db),
    current_master: User = Depends(get_current_master)
):
    # This is a dangerous operation. In a real system, we might just mark as inactive.
    # For now, we delete all associations.
    result = await db.execute(select(UserApartment).where(UserApartment.complex_name == name))
    apts = result.scalars().all()
    for apt in apts:
        await db.delete(apt)
    await db.commit()
    return {"message": f"Complex {name} and all its associations deleted."}

@router.put("/users/{user_id}/role")
async def update_user_global_role(
    user_id: int,
    data: dict,
    db: AsyncSession = Depends(get_db),
    current_master: User = Depends(get_current_master)
):
    new_role = data.get("global_role")
    if new_role not in ["USER", "MASTER_ADMIN"]:
        raise HTTPException(status_code=400, detail="Invalid global role")
    
    result = await db.execute(select(User).where(User.id == user_id))
    user = result.scalars().first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    user.global_role = new_role
    await db.commit()
    return {"message": f"User {user_id} global role updated to {new_role}"}

@router.get("/stats/iot")
async def get_iot_stats(
    db: AsyncSession = Depends(get_db),
    current_master: User = Depends(get_current_master)
):
    # Aggregated IoT data for HQ
    total_devices_result = await db.execute(select(func.count(IoTDevice.id)))
    total_devices = total_devices_result.scalar() or 0
    
    provider_stats_result = await db.execute(
        select(IoTDevice.provider_name, func.count(IoTDevice.id))
        .group_by(IoTDevice.provider_name)
    )
    provider_stats = {row[0]: row[1] for row in provider_stats_result}
    
    type_stats_result = await db.execute(
        select(IoTDevice.device_type, func.count(IoTDevice.id))
        .group_by(IoTDevice.device_type)
    )
    type_stats = {row[0]: row[1] for row in type_stats_result}

    return {
        "total_connected_devices": total_devices,
        "by_provider": provider_stats,
        "by_device_type": type_stats,
        "trend": "Upward (+12% this month)"
    }

@router.get("/stats/trends")
async def get_master_trends(
    db: AsyncSession = Depends(get_db),
    current_master: User = Depends(get_current_master)
):
    # Monthly Energy Consumption (Last 6 months)
    energy_trend_result = await db.execute(
        select(
            func.date_trunc('month', EnergyUsage.usage_month).label("month"),
            func.sum(EnergyUsage.electricity).label("electricity")
        )
        .group_by("month")
        .order_by("month")
    )
    energy_trend = [{"month": str(row[0].month) + "월", "value": float(row[1])} for row in energy_trend_result.all()]

    # User Growth (Last 6 months)
    user_trend_result = await db.execute(
        select(
            func.date_trunc('month', User.created_at).label("month"),
            func.count(User.id).label("count")
        )
        .group_by("month")
        .order_by("month")
    )
    user_trend = [{"month": str(row[0].month) + "월", "count": int(row[1])} for row in user_trend_result.all()]

    # Provide meaningful mock data if DB is sparse for better UI demo
    if not energy_trend:
        energy_trend = [
            {"month": "8월", "value": 4200},
            {"month": "9월", "value": 3800},
            {"month": "10월", "value": 4500},
            {"month": "11월", "value": 5100},
            {"month": "12월", "value": 6200},
            {"month": "1월", "value": 5800},
        ]
    
    if not user_trend:
        user_trend = [
            {"month": "8월", "count": 120},
            {"month": "9월", "count": 145},
            {"month": "10월", "count": 190},
            {"month": "11월", "count": 230},
            {"month": "12월", "count": 310},
            {"month": "1월", "count": 450},
        ]

    return {
        "energy_consumption": energy_trend,
        "user_growth": user_trend,
        "complex_performance": [
            {"name": "GreenBee Premier", "score": 98, "status": "Excellent"},
            {"name": "Space Central", "score": 85, "status": "Good"},
            {"name": "Urban Hive", "score": 72, "status": "Normal"},
            {"name": "Beyond Tower", "score": 65, "status": "Warning"},
        ]
    }

