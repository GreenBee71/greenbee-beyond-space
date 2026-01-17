from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy import desc
from typing import List

from ...db.database import get_db
from ...models.models import AdminFee, EnergyUsage
from ...schemas.finance import EnergyCoachResponse, EnergyCoachTip, EnergyUsageRead
from datetime import datetime

router = APIRouter()

@router.get("/fees/latest")
async def get_latest_fee(db: AsyncSession = Depends(get_db)):
    result = await db.execute(
        select(AdminFee).order_by(desc(AdminFee.billing_month)).limit(1)
    )
    fee = result.scalars().first()
    if not fee:
        raise HTTPException(status_code=404, detail="No fees found")
    return fee

@router.get("/energy/monthly")
async def get_energy_history(db: AsyncSession = Depends(get_db)):
    result = await db.execute(
        select(EnergyUsage).order_by(EnergyUsage.usage_month.asc()).limit(6)
    )
    return result.scalars().all()

@router.get("/energy/coach", response_model=EnergyCoachResponse)
async def get_energy_coach_tips(db: AsyncSession = Depends(get_db)):
    """
    AI Energy Coach logic.
    Analyzes current user's usage vs average peers and provides tips.
    """
    result = await db.execute(
        select(EnergyUsage).order_by(desc(EnergyUsage.usage_month)).limit(1)
    )
    latest = result.scalars().first()
    
    if not latest:
        raise HTTPException(status_code=404, detail="No usage data found")

    # Dynamic Analysis for Phase 5
    electricity_diff = latest.electricity - latest.peer_electricity
    water_diff = latest.water - latest.peer_water
    
    # Base score
    score = 80
    tips = []
    
    if electricity_diff > 0:
        score -= min(15, int(electricity_diff / 5))
        tips.append(EnergyCoachTip(
            title="Standby Power Alert",
            content=f"Your electricity usage is {electricity_diff}kWh higher than your peers. Try unplugging chargers and appliances when not in use.",
            impact_level="HIGH",
            category="SAVING"
        ))
    else:
        score += 5
        tips.append(EnergyCoachTip(
            title="Electricity Saver",
            content="You're using less electricity than average! Consider sharing your tips with neighbors.",
            impact_level="LOW",
            category="PEER_COMPARE"
        ))

    if water_diff > 0:
        score -= min(10, int(water_diff / 2))
        tips.append(EnergyCoachTip(
            title="Smart Watering",
            content="Water usage is slightly above average. Checking for minor leaks or using eco-mode on appliances can help.",
            impact_level="MEDIUM",
            category="SAVING"
        ))
    
    # Cap score
    score = max(0, min(100, score))
    
    if score >= 90:
        summary = "Outstanding! You are a GreenBee Energy Master. Your habits are setting a great example."
    elif score >= 70:
        summary = "Good effort. With a few minor adjustments, you can further reduce your footprint."
    else:
        summary = "Energy saving opportunity detected. Follow the tips below to optimize your usage."

    return EnergyCoachResponse(
        summary=summary,
        tips=tips,
        score=score,
        analysis_date=datetime.now()
    )
