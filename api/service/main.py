from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy import text
from datetime import date, timedelta
import random

from .db.database import get_db, engine, Base, AsyncSessionLocal
from .models.models import User, UserApartment, AdminFee, EnergyUsage, Visitor, Vote, CommunityPost
from .api.endpoints import finance, living, auth, admin, master, greenpay, iot
from .core.security import get_password_hash

app = FastAPI(
    title="GreenBee Beyond Space API",
    root_path="/greenbee_beyond_space"
)

# --- Static Files Mounting (Unified Build) ---
import os
from fastapi.staticfiles import StaticFiles

# api/service/www is where assets are copied to
base_dir = os.path.dirname(os.path.abspath(__file__))
www_dir = os.path.join(base_dir, "www")

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Admin Web and Resident App are mounted at /admin and /app
# These will be reached via /greenbee_beyond_space/admin and /greenbee_beyond_space/app
if os.path.exists(os.path.join(www_dir, "admin")):
    print(f">>> Mounting Admin Web at /admin from {os.path.join(www_dir, 'admin')}")
    app.mount("/admin", StaticFiles(directory=os.path.join(www_dir, "admin"), html=True), name="admin_web")

if os.path.exists(os.path.join(www_dir, "app")):
    print(f">>> Mounting Resident App at /app from {os.path.join(www_dir, 'app')}")
    app.mount("/app", StaticFiles(directory=os.path.join(www_dir, "app"), html=True), name="resident_app")

# --- Routers ---
# All API routers are prefixed with /api
# These will be reached via /greenbee_beyond_space/api/...
app.include_router(auth.router, prefix="/api/auth", tags=["auth"])
app.include_router(finance.router, prefix="/api/finance", tags=["finance"])
app.include_router(living.router, prefix="/api/living", tags=["living"])
app.include_router(admin.router, prefix="/api/admin", tags=["admin"])
app.include_router(master.router, prefix="/api/master", tags=["master"])
app.include_router(greenpay.router, prefix="/api/greenpay", tags=["greenpay"])
app.include_router(iot.router, prefix="/api/iot", tags=["iot"])

@app.get("/api/health")
async def health_check():
    return {"status": "healthy"}

# --- Data Seeding ---
async def seed_data(session: AsyncSession):
    result = await session.execute(select(User))
    if result.scalars().first():
        return

    print(">>> Seeding Mock Data...")
    
    user = User(
        email="resident@greenbee.com", 
        password_hash=get_password_hash("greenbee123"), 
        full_name="Kim Resident", 
        is_verified=True,
        global_role="USER"
    )
    admin = User(
        email="admin@greenbee.com", 
        password_hash=get_password_hash("admin123"), 
        full_name="Lee Admin", 
        is_verified=True,
        global_role="USER"
    )
    master_admin = User(
        email="master@greenbee.com",
        password_hash=get_password_hash("master123"),
        full_name="System Master",
        is_verified=True,
        global_role="MASTER_ADMIN"
    )
    session.add_all([user, admin, master_admin])
    await session.flush()
    
    apt = UserApartment(user_id=user.id, complex_name="GreenBee Premier", dong="101", ho="1204", role="RESIDENT")
    admin_apt = UserApartment(user_id=admin.id, complex_name="GreenBee Premier", dong="MGT", ho="OFFICE", role="ADMIN")
    session.add_all([apt, admin_apt])
    await session.flush()
    
    today = date.today()
    for i in range(6):
        month_date = date(today.year, today.month, 1) - timedelta(days=30*i)
        month_date = month_date.replace(day=1)
        
        details = {
            "general_mgmt": 85000,
            "security": 45000,
            "cleaning": 35000,
            "elevator": 12000,
            "community": 10000,
            "energy_electric": random.randint(30000, 60000),
            "energy_water": random.randint(10000, 20000),
            "energy_heating": random.randint(0, 100000) if i < 3 else 10000
        }
        total = sum(details.values())
        
        fee = AdminFee(
            user_apartment_id=apt.id,
            billing_month=month_date,
            total_amount=total,
            status="UNPAID" if i == 0 else "PAID",
            details=details
        )
        session.add(fee)
        
        energy = EnergyUsage(
            user_apartment_id=apt.id,
            usage_month=month_date,
            electricity=details["energy_electric"] // 200,
            water=details["energy_water"] // 1000,
            gas=random.randint(10, 50),
            heating=details["energy_heating"] // 500,
            peer_electricity=random.randint(150, 250), # kWh
            peer_water=random.randint(10, 20)          # m3
        )
        session.add(energy)

    visitors_data = [
        {"car": "12가 3456", "name": "Courier", "purpose": "Delivery", "status": "APPROVED", "days_offset": 0},
        {"car": "56나 7890", "name": "Mom", "purpose": "Family Visit", "status": "APPROVED", "days_offset": 2},
        {"car": "99하 1111", "name": "Pizza", "purpose": "Food Delivery", "status": "PENDING", "days_offset": 0},
    ]
    for v in visitors_data:
        visit = Visitor(
            user_apartment_id=apt.id,
            car_number=v["car"],
            visitor_name=v["name"],
            visit_date=date.today() - timedelta(days=v["days_offset"]),
            purpose=v["purpose"],
            status=v["status"]
        )
        session.add(visit)

    vote = Vote(
        title="Installation of Electric Vehicle Charging Station",
        description="We are discussing adding 5 more EV chargers in B2 Parking Lot.",
        start_date=date.today(),
        end_date=date.today() + timedelta(days=7),
        is_active=True,
        options=["Agree", "Disagree"],
        results={}
    )
    session.add(vote)
    
    # Community Posts (for search)
    posts = [
        CommunityPost(author_id=user.id, title="Gym Opening Hours", content="The complex gym will now be open until 11 PM starting next week.", category="NOTICE"),
        CommunityPost(author_id=user.id, title="Second-hand Bicycle for Sale", content="Giant escape 3, good condition. Selling for $100.", category="MARKET"),
        CommunityPost(author_id=user.id, title="Recommendation for local cafe", content="I found a really nice coffee shop near the North Gate.", category="CHAT"),
        CommunityPost(author_id=user.id, title="EV Charging Etiquette", content="Please move your car once charging is complete to allow others to use the station.", category="NOTICE")
    ]
    session.add_all(posts)
        
    await session.commit()
    print(">>> Seeding Complete.")

@app.on_event("startup")
async def startup_event():
    async with engine.begin() as conn:
        await conn.execute(text("CREATE EXTENSION IF NOT EXISTS vector"))
        await conn.run_sync(Base.metadata.create_all)
    
    async with AsyncSessionLocal() as session:
        await seed_data(session)
