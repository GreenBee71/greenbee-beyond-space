from pydantic import BaseModel, EmailStr
from datetime import date, datetime
from typing import List, Optional
from .resident import VisitorRead
from .auth import UserRead

class VisitorStatusUpdate(BaseModel):
    status: str # APPROVED, REJECTED

class UnverifiedUserRead(BaseModel):
    id: int
    user_id: int
    complex_name: str
    dong: str
    ho: str
    role: str
    email: EmailStr
    full_name: Optional[str] = None

    class Config:
        from_attributes = True
