from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from jose import JWTError, jwt

from ...db.database import get_db
from ...models.models import User
from ...core.security import verify_password, create_access_token, SECRET_KEY, ALGORITHM
from ...schemas.auth import Token, UserRead

router = APIRouter()
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="auth/login")

async def get_current_user(token: str = Depends(oauth2_scheme), db: AsyncSession = Depends(get_db)):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        email: str = payload.get("sub")
        if email is None:
            raise credentials_exception
    except JWTError:
        raise credentials_exception
    
    result = await db.execute(select(User).where(User.email == email))
    user = result.scalars().first()
    if user is None:
        raise credentials_exception
    return user

@router.post("/login", response_model=Token)
async def login(form_data: OAuth2PasswordRequestForm = Depends(), db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(User).where(User.email == form_data.username))
    user = result.scalars().first()
    
    if not user or not verify_password(form_data.password, user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    access_token = create_access_token(data={"sub": user.email})
    return {"access_token": access_token, "token_type": "bearer"}

from ...models.models import User, UserApartment

@router.get("/me", response_model=UserRead)
async def read_users_me(
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    # Fetch roles
    result = await db.execute(
        select(UserApartment.role).where(UserApartment.user_id == current_user.id)
    )
    # If user has multiple roles, ADMIN takes priority for redirection
    roles = result.scalars().all()
    user_role = "ADMIN" if "ADMIN" in roles else ("OWNER" if "OWNER" in roles else "RESIDENT")
    
    # Create dict for response_model mapping
    user_data = {
        "id": current_user.id,
        "email": current_user.email,
        "full_name": current_user.full_name,
        "is_verified": current_user.is_verified,
        "role": user_role,
        "global_role": current_user.global_role
    }
    return user_data
