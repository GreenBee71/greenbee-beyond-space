from pydantic import BaseModel
from datetime import date, datetime
from typing import List, Dict, Optional

class VisitorCreate(BaseModel):
    car_number: str
    visitor_name: str
    visit_date: date
    purpose: str

class VisitorRead(VisitorCreate):
    id: int
    user_apartment_id: int
    status: str
    created_at: datetime

    class Config:
        from_attributes = True

class VoteRead(BaseModel):
    id: int
    title: str
    description: str
    start_date: datetime
    end_date: datetime
    is_active: bool
    options: List[str]
    results: Dict

    class Config:
        from_attributes = True

class SearchRequest(BaseModel):
    query: str
    limit: int = 5

class SearchResult(BaseModel):
    id: int
    title: str
    content: Optional[str] = None
    category: str
    score: float

# --- New Content Schemas ---
class EnergyChallengeRead(BaseModel):
    id: int
    title: str
    description: str
    start_date: datetime
    end_date: datetime
    goal_percent: int
    reward_points: int
    is_active: bool

    class Config:
        from_attributes = True

class UserChallengeStatusRead(BaseModel):
    challenge_id: int
    current_savings: float
    is_completed: bool
    joined_at: datetime
    challenge: EnergyChallengeRead

    class Config:
        from_attributes = True

class EVChargerRead(BaseModel):
    id: int
    complex_name: str
    location: str
    status: str
    current_user_id: Optional[int]

    class Config:
        from_attributes = True

class FacilityRead(BaseModel):
    id: int
    name: str
    capacity: int
    is_active: bool
    # Simple occupancy for mock
    current_occupancy: int = 0

    class Config:
        from_attributes = True

class DeliveryRead(BaseModel):
    id: int
    courier: str
    tracking_number: str
    status: str
    arrived_at: datetime
    picked_up_at: Optional[datetime]

    class Config:
        from_attributes = True

class GreenShareItemRead(BaseModel):
    id: int
    author_id: int
    title: str
    description: Optional[str] = None
    category: str
    price_points: int
    status: str
    created_at: datetime

    class Config:
        from_attributes = True

class TalentExchangeRead(BaseModel):
    id: int
    provider_id: int
    title: str
    description: Optional[str] = None
    category: str
    price_points: int
    estimated_time: str
    status: str
    created_at: datetime

    class Config:
        from_attributes = True

class SocialClubRead(BaseModel):
    id: int
    founder_id: int
    name: str
    description: Optional[str] = None
    category: str
    image_url: Optional[str] = None
    created_at: datetime

    class Config:
        from_attributes = True

class HomeCareRequestCreate(BaseModel):
    start_date: date
    end_date: date
    care_types: List[str]
    notes: Optional[str] = None

class HomeCareRequestRead(HomeCareRequestCreate):
    id: int
    user_id: int
    status: str
    created_at: datetime

    class Config:
        from_attributes = True
