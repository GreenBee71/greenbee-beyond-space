from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker
import os
import urllib.parse

# Load DB Pass from Env
DB_PASS = os.getenv("POSTGRES_PASSWORD", "greenbee_pass")
# URL Encode password to handle special chars safe
encoded_pass = urllib.parse.quote_plus(DB_PASS)

DB_HOST = os.getenv("DB_HOST", "localhost")
DB_NAME = os.getenv("POSTGRES_DB", "greenbee_beyond_space.db")
DB_USER = os.getenv("POSTGRES_USER", "greenbee")

DATABASE_URL = f"postgresql+asyncpg://{DB_USER}:{encoded_pass}@{DB_HOST}:5432/{DB_NAME}"

engine = create_async_engine(DATABASE_URL, echo=True)

AsyncSessionLocal = sessionmaker(
    bind=engine,
    class_=AsyncSession,
    expire_on_commit=False,
    autocommit=False,
    autoflush=False,
)

from sqlalchemy.orm import declarative_base

Base = declarative_base()

async def get_db():
    async with AsyncSessionLocal() as session:
        try:
            yield session
        finally:
            await session.close()
