from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy import update
from typing import List

from ...db.database import get_db
from ...models.models import User, UserApartment, Visitor
from ...schemas.admin import VisitorStatusUpdate, UnverifiedUserRead
from ...schemas.resident import VisitorRead
from .auth import get_current_user

router = APIRouter()

async def get_current_admin(current_user: User = Depends(get_current_user), db: AsyncSession = Depends(get_db)):
    result = await db.execute(
        select(UserApartment).where(
            UserApartment.user_id == current_user.id,
            UserApartment.role == "ADMIN"
        )
    )
    admin_apt = result.scalars().first()
    if not admin_apt:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="The user does not have enough privileges"
        )
    return current_user

@router.get("/visitors", response_model=List[VisitorRead])
async def get_all_visitors(
    db: AsyncSession = Depends(get_db),
    current_admin: User = Depends(get_current_admin)
):
    # In a real app, we'd filter by complex_name of the admin
    result = await db.execute(select(Visitor).order_by(Visitor.visit_date.desc()))
    return result.scalars().all()

@router.patch("/visitors/{visitor_id}", response_model=VisitorRead)
async def update_visitor_status(
    visitor_id: int,
    status_update: VisitorStatusUpdate,
    db: AsyncSession = Depends(get_db),
    current_admin: User = Depends(get_current_admin)
):
    result = await db.execute(select(Visitor).where(Visitor.id == visitor_id))
    visitor = result.scalars().first()
    if not visitor:
        raise HTTPException(status_code=404, detail="Visitor not found")
    
    visitor.status = status_update.status
    await db.commit()
    await db.refresh(visitor)
    return visitor

@router.get("/users/unverified", response_model=List[UnverifiedUserRead])
async def get_unverified_users(
    db: AsyncSession = Depends(get_db),
    current_admin: User = Depends(get_current_admin)
):
    query = (
        select(UserApartment, User)
        .join(User, UserApartment.user_id == User.id)
        .where(User.is_verified == False)
    )
    result = await db.execute(query)
    
    unverified = []
    for apt, user in result.all():
        unverified.append(UnverifiedUserRead(
            id=apt.id,
            user_id=user.id,
            complex_name=apt.complex_name,
            dong=apt.dong,
            ho=apt.ho,
            role=apt.role,
            email=user.email,
            full_name=user.full_name
        ))
    return unverified

@router.post("/users/{user_id}/verify")
async def verify_user(
    user_id: int,
    db: AsyncSession = Depends(get_db),
    current_admin: User = Depends(get_current_admin)
):
    result = await db.execute(select(User).where(User.id == user_id))
    user = result.scalars().first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    user.is_verified = True
    await db.commit()
    return {"message": f"User {user.email} verified successfully"}
