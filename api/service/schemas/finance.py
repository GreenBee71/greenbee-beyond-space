from pydantic import BaseModel
from datetime import date, datetime
from typing import List, Dict, Optional

class AdminFeeRead(BaseModel):
    id: int
    user_apartment_id: int
    billing_month: date
    total_amount: float
    status: str
    details: Dict
    created_at: datetime

    class Config:
        from_attributes = True

class EnergyUsageRead(BaseModel):
    id: int
    user_apartment_id: int
    usage_month: date
    electricity: int
    water: int
    gas: int
    heating: int
    peer_electricity: int
    peer_water: int

    class Config:
        from_attributes = True

class EnergyCoachTip(BaseModel):
    title: str
    content: str
    impact_level: str # HIGH, MEDIUM, LOW
    category: str # SAVING, ENVIRONMENT, PEER_COMPARE

class EnergyCoachResponse(BaseModel):
    summary: str
    tips: List[EnergyCoachTip]
    score: int # 0-100 energy saving score
    analysis_date: datetime
