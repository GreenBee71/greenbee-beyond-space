from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from typing import List

from ...db.database import get_db
from ...models.models import IoTDevice, IoTScenario, IoTScenarioAction, EnergyUsage, ConciergeSuggestion, HomeEquipment
from ...schemas.iot import IoTDeviceCreate, IoTDeviceRead, IoTDeviceUpdate, IoTScenarioCreate, IoTScenarioRead

router = APIRouter()

@router.post("/devices", response_model=IoTDeviceRead)
async def register_device(device: IoTDeviceCreate, db: AsyncSession = Depends(get_db)):
    """
    Registers a new IoT device with its provider configuration.
    """
    new_device = IoTDevice(
        user_id=1, 
        device_name=device.device_name,
        device_type=device.device_type,
        provider_name=device.provider_name,
        connection_config=device.connection_config
    )
    db.add(new_device)
    await db.commit()
    await db.refresh(new_device)
    return new_device

@router.get("/devices", response_model=List[IoTDeviceRead])
async def get_my_devices(db: AsyncSession = Depends(get_db)):
    """
    Returns all registered IoT devices for the current user.
    """
    result = await db.execute(select(IoTDevice).where(IoTDevice.user_id == 1))
    return result.scalars().all()

@router.delete("/devices/{device_id}")
async def remove_device(device_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(IoTDevice).where(IoTDevice.id == device_id))
    device = result.scalar_one_or_none()
    if not device:
        raise HTTPException(status_code=404, detail="Device not found")
    
    await db.delete(device)
    await db.commit()
    return {"message": "Device removed"}

@router.post("/scenarios", response_model=IoTScenarioRead)
async def create_scenario(scenario: IoTScenarioCreate, db: AsyncSession = Depends(get_db)):
    new_scenario = IoTScenario(
        user_id=1,
        name=scenario.name,
        icon=scenario.icon
    )
    db.add(new_scenario)
    await db.flush()

    for action in scenario.actions:
        new_action = IoTScenarioAction(
            scenario_id=new_scenario.id,
            device_id=action.device_id,
            target_state=action.target_state
        )
        db.add(new_action)
    
    await db.commit()
    await db.refresh(new_scenario)
    return new_scenario

@router.get("/scenarios", response_model=List[IoTScenarioRead])
async def get_scenarios(db: AsyncSession = Depends(get_db)):
    from sqlalchemy.orm import selectinload
    result = await db.execute(
        select(IoTScenario)
        .where(IoTScenario.user_id == 1)
        .options(selectinload(IoTScenario.actions))
    )
    return result.scalars().all()

@router.post("/scenarios/{scenario_id}/trigger")
async def trigger_scenario(scenario_id: int, db: AsyncSession = Depends(get_db)):
    """
    Simulates triggering all actions in a scenario.
    """
    from sqlalchemy.orm import selectinload
    result = await db.execute(
        select(IoTScenario)
        .where(IoTScenario.id == scenario_id)
        .options(selectinload(IoTScenario.actions))
    )
    scenario = result.scalar_one_or_none()
    if not scenario:
        raise HTTPException(status_code=404, detail="Scenario not found")
    
    executed_actions = []
    for action in scenario.actions:
        executed_actions.append({
            "device_id": action.device_id,
            "command_sent": action.target_state,
            "status": "SUCCESS"
        })

    return {
        "scenario": scenario.name,
        "status": "ORCHESTRATED",
        "details": executed_actions
    }

@router.get("/garden-status")
async def get_garden_status(db: AsyncSession = Depends(get_db)):
    from sqlalchemy import desc
    result = await db.execute(select(EnergyUsage).where(EnergyUsage.user_apartment_id == 1).order_by(desc(EnergyUsage.usage_month)))
    latest_usage = result.scalars().first()
    
    base_score = 85
    if latest_usage:
        if latest_usage.electricity < latest_usage.peer_electricity:
            base_score += 10
        else:
            base_score -= 5
            
    result = await db.execute(select(IoTDevice).where(IoTDevice.user_id == 1))
    devices = result.scalars().all()
    active_count = len([d for d in devices if d.is_active])
    
    final_score = max(0, min(100, base_score - (active_count * 2)))
    level = "Lush" if final_score > 80 else ("Growing" if final_score > 40 else "Dry")
    
    return {
        "score": final_score,
        "level": level,
        "active_devices_impact": active_count * -2,
        "message": f"Your garden is {level.lower()} thanks to your energy mindfulness."
    }

@router.get("/suggestions")
async def get_concierge_suggestions(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(ConciergeSuggestion).where(ConciergeSuggestion.user_id == 1, ConciergeSuggestion.is_read == False))
    suggestions = result.scalars().all()
    
    if not suggestions:
        mock_data = [
            {
                "title": "Air Purifier Filter Alert",
                "description": "Your air purifier filter usage is at 92%. We recommend ordering a replacement soon.",
                "type": "IoT_MAINTENANCE",
                "action_label": "Order Filter"
            },
            {
                "title": "Laundry Service Suggestion",
                "description": "We noticed dynamic одежда (clothing) delivery today. Would you like to schedule a professional laundry pickup for tomorrow?",
                "type": "SERVICE_RESERVATION",
                "action_label": "Book Now"
            }
        ]
        for data in mock_data:
            new_s = ConciergeSuggestion(user_id=1, **data)
            db.add(new_s)
        await db.commit()
        result = await db.execute(select(ConciergeSuggestion).where(ConciergeSuggestion.user_id == 1, ConciergeSuggestion.is_read == False))
        suggestions = result.scalars().all()

    return suggestions

# --- Home Infrastructure (Wall-pad, Door-lock) ---
@router.get("/home-equipments")
async def get_home_equipments(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(HomeEquipment).where(HomeEquipment.user_id == 1))
    equipments = result.scalars().all()
    
    if not equipments:
        mock_infra = [
            {"equipment_type": "WALLPAD", "equipment_name": "Main Wallpad Hub", "manufacturer": "COMMAX", "current_state": {"message": "All systems normal"}},
            {"equipment_type": "DOORLOCK", "equipment_name": "Entrance Doorlock", "manufacturer": "YALE", "current_state": {"locked": True}},
            {"equipment_type": "THERMOSTAT", "equipment_name": "Climate Control", "manufacturer": "HONEYWELL", "current_state": {"temp": 22.5}},
            {"equipment_type": "GAS_VALVE", "equipment_name": "Kitchen Gas Valve", "manufacturer": "DAESUNG", "current_state": {"status": "CLOSED"}}
        ]
        for item in mock_infra:
            new_eq = HomeEquipment(user_id=1, **item)
            db.add(new_eq)
        await db.commit()
        result = await db.execute(select(HomeEquipment).where(HomeEquipment.user_id == 1))
        equipments = result.scalars().all()
        
    return equipments

@router.post("/home-equipments/{equipment_id}/control")
async def control_home_equipment(equipment_id: int, action: dict, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(HomeEquipment).where(HomeEquipment.id == equipment_id))
    equipment = result.scalars().first()
    if not equipment:
        raise HTTPException(status_code=404, detail="Equipment not found")
    
    new_state = equipment.current_state.copy()
    new_state.update(action)
    equipment.current_state = new_state
    
    await db.commit()
    return {"message": f"Command sent to {equipment.equipment_name}", "current_state": new_state}
