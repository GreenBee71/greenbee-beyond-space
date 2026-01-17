from pydantic import BaseModel
from datetime import datetime
from typing import List, Optional
from decimal import Decimal

class WalletRead(BaseModel):
    id: int
    user_id: int
    balance: Decimal
    currency: str
    updated_at: datetime

    class Config:
        from_attributes = True

class TransactionRead(BaseModel):
    id: int
    wallet_id: int
    amount: Decimal
    type: str
    description: Optional[str]
    status: str
    created_at: datetime

    class Config:
        from_attributes = True

class ChargeRequest(BaseModel):
    amount: Decimal

class PaymentRequest(BaseModel):
    amount: Decimal
    description: str
