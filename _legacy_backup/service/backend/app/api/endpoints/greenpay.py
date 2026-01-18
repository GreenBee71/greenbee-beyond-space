from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from typing import List, Optional
from decimal import Decimal

from ...db.database import get_db
from ...models.models import User, Wallet, Transaction
from ...schemas.greenpay import WalletRead, TransactionRead, ChargeRequest, PaymentRequest
from .auth import get_current_user

router = APIRouter()

@router.get("/wallet", response_model=WalletRead)
async def get_wallet(
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    result = await db.execute(select(Wallet).where(Wallet.user_id == current_user.id))
    wallet = result.scalars().first()
    
    if not wallet:
        # Auto-create wallet if not exists
        wallet = Wallet(user_id=current_user.id, balance=Decimal("0.00"))
        db.add(wallet)
        await db.commit()
        await db.refresh(wallet)
    
    return wallet

@router.get("/transactions", response_model=List[TransactionRead])
async def get_transactions(
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    result = await db.execute(select(Wallet).where(Wallet.user_id == current_user.id))
    wallet = result.scalars().first()
    if not wallet:
        return []
    
    result = await db.execute(
        select(Transaction)
        .where(Transaction.wallet_id == wallet.id)
        .order_by(Transaction.created_at.desc())
    )
    return result.scalars().all()

@router.post("/charge", response_model=TransactionRead)
async def charge_wallet(
    req: ChargeRequest,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    result = await db.execute(select(Wallet).where(Wallet.user_id == current_user.id))
    wallet = result.scalars().first()
    
    if not wallet:
        wallet = Wallet(user_id=current_user.id, balance=Decimal("0.00"))
        db.add(wallet)
        await db.flush()

    wallet.balance += req.amount
    transaction = Transaction(
        wallet_id=wallet.id,
        amount=req.amount,
        type="CHARGE",
        description="Wallet Charge",
        status="COMPLETED"
    )
    db.add(transaction)
    await db.commit()
    await db.refresh(transaction)
    return transaction

@router.post("/pay", response_model=TransactionRead)
async def pay_from_wallet(
    req: PaymentRequest,
    fee_id: Optional[int] = None, # Optional fee_id to mark as paid
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    result = await db.execute(select(Wallet).where(Wallet.user_id == current_user.id))
    wallet = result.scalars().first()
    
    if not wallet or wallet.balance < req.amount:
        raise HTTPException(status_code=400, detail="Insufficient balance")

    wallet.balance -= req.amount
    
    if fee_id:
        from ...models.models import AdminFee
        fee_result = await db.execute(select(AdminFee).where(AdminFee.id == fee_id))
        fee = fee_result.scalars().first()
        if fee:
            fee.status = "PAID"

    transaction = Transaction(
        wallet_id=wallet.id,
        amount=-req.amount,
        type="PAYMENT",
        description=req.description,
        status="COMPLETED"
    )
    db.add(transaction)
    await db.commit()
    await db.refresh(transaction)
    return transaction
