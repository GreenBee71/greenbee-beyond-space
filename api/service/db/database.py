from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker
import os
import urllib.parse

# DB Secrets from Environment
DB_USER = os.getenv("POSTGRES_USER", "greenbee")
DB_PASS = os.getenv("POSTGRES_PASSWORD", "password")
DB_NAME = os.getenv("POSTGRES_DB", "greenbee_beyond_space")
DB_HOST = os.getenv("DB_HOST", "localhost")  # For local/docker-compose
INSTANCE_CONNECTION_NAME = os.getenv("INSTANCE_CONNECTION_NAME")  # e.g. project:region:instance

# URL Encode password for special characters
encoded_pass = urllib.parse.quote_plus(DB_PASS)

# Construct Database URL
if INSTANCE_CONNECTION_NAME:
    # Production Cloud Run (Unix Socket)
    DATABASE_URL = (
        f"postgresql+asyncpg://{DB_USER}:{encoded_pass}@/{DB_NAME}"
        f"?host=/cloudsql/{INSTANCE_CONNECTION_NAME}"
    )
else:
    # Local or Normal TCP
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
