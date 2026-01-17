from sqlalchemy import Column, Integer, String, Boolean, DateTime, ForeignKey, Date, Numeric, Text, JSON
from sqlalchemy.orm import relationship, declarative_base
from sqlalchemy.sql import func
from pgvector.sqlalchemy import Vector
from ..db.database import Base

# --- Users & Auth ---
class User(Base):
    __tablename__ = "users"
    
    id = Column(Integer, primary_key=True, index=True)
    email = Column(String(255), unique=True, nullable=False)
    password_hash = Column(String(255), nullable=False)
    full_name = Column(String(100))
    phone_number = Column(String(20))
    is_verified = Column(Boolean, default=False)
    global_role = Column(String(20), default="USER") # USER, MASTER_ADMIN
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    apartments = relationship("UserApartment", back_populates="user")
    posts = relationship("CommunityPost", back_populates="author")
    interests = relationship("UserInterest", back_populates="user", uselist=False)

class UserApartment(Base):
    __tablename__ = "user_apartments"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    complex_name = Column(String(100), nullable=False)
    dong = Column(String(10), nullable=False)
    ho = Column(String(10), nullable=False)
    role = Column(String(20), default="RESIDENT") # RESIDENT, OWNER, ADMIN
    verified_at = Column(DateTime(timezone=True))

    user = relationship("User", back_populates="apartments")
    admin_fees = relationship("AdminFee", back_populates="apartment")
    energy_usage = relationship("EnergyUsage", back_populates="apartment")
    visitors = relationship("Visitor", back_populates="apartment")

# --- Fintech (Admin Fees) ---
class AdminFee(Base):
    __tablename__ = "admin_fees"
    
    id = Column(Integer, primary_key=True, index=True)
    user_apartment_id = Column(Integer, ForeignKey("user_apartments.id"))
    billing_month = Column(Date, nullable=False) # First day of the month
    total_amount = Column(Numeric(12, 2), nullable=False)
    status = Column(String(20), default="UNPAID")
    details = Column(JSON) # Detailed line items
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    apartment = relationship("UserApartment", back_populates="admin_fees")

class EnergyUsage(Base):
    __tablename__ = "energy_usage"
    
    id = Column(Integer, primary_key=True, index=True)
    user_apartment_id = Column(Integer, ForeignKey("user_apartments.id"))
    usage_month = Column(Date, nullable=False) # First day of the month
    
    # Usage metrics
    electricity = Column(Integer, default=0) # kWh
    water = Column(Integer, default=0) # m3
    gas = Column(Integer, default=0) # m3
    heating = Column(Integer, default=0) # Mcal
    
    # Peer comparison stats (Pre-calculated for simplicity in Phase 1)
    peer_electricity = Column(Integer, default=0)
    peer_water = Column(Integer, default=0)
    
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    apartment = relationship("UserApartment", back_populates="energy_usage")

# --- Convenience (Reservations) ---
class Facility(Base):
    __tablename__ = "facilities"
    
    id = Column(Integer, primary_key=True, index=True)
    complex_name = Column(String(100), nullable=False)
    name = Column(String(50), nullable=False)
    capacity = Column(Integer, default=10)
    is_active = Column(Boolean, default=True)

class Reservation(Base):
    __tablename__ = "reservations"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    facility_id = Column(Integer, ForeignKey("facilities.id"))
    start_time = Column(DateTime(timezone=True), nullable=False)
    end_time = Column(DateTime(timezone=True), nullable=False)
    status = Column(String(20), default="BOOKED")

# --- Community & AI ---
class CommunityPost(Base):
    __tablename__ = "community_posts"
    
    id = Column(Integer, primary_key=True, index=True)
    author_id = Column(Integer, ForeignKey("users.id"))
    title = Column(String(255))
    content = Column(Text)
    category = Column(String(50)) # NOTICE, MARKET, CHAT
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    author = relationship("User", back_populates="posts")
    embedding = relationship("PostEmbedding", back_populates="post", uselist=False, cascade="all, delete-orphan")

class PostEmbedding(Base):
    __tablename__ = "post_embeddings"
    
    post_id = Column(Integer, ForeignKey("community_posts.id"), primary_key=True)
    # Using 1536 dim (OpenAI standard)
    embedding = Column(Vector(1536))
    
    post = relationship("CommunityPost", back_populates="embedding")

class UserInterest(Base):
    __tablename__ = "user_interests"
    
    user_id = Column(Integer, ForeignKey("users.id"), primary_key=True)
    interest_vector = Column(Vector(1536))
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())

    user = relationship("User", back_populates="interests")

# --- Living Support (Visitor & Voting) ---
class Visitor(Base):
    __tablename__ = "visitors"

    id = Column(Integer, primary_key=True, index=True)
    user_apartment_id = Column(Integer, ForeignKey("user_apartments.id"))
    car_number = Column(String(20), nullable=False)
    visitor_name = Column(String(50))
    visit_date = Column(Date, nullable=False)
    purpose = Column(String(100))
    status = Column(String(20), default="PENDING") # PENDING, APPROVED, REJECTED
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    apartment = relationship("UserApartment", back_populates="visitors")

class Vote(Base):
    __tablename__ = "votes"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String(255), nullable=False)
    description = Column(Text)
    start_date = Column(DateTime(timezone=True), nullable=False)
    end_date = Column(DateTime(timezone=True), nullable=False)
    is_active = Column(Boolean, default=True)
    options = Column(JSON) # List of options e.g. ["Yes", "No"]
    
    # Store aggregated results simply for Phase 1
    results = Column(JSON, default={}) 

    participations = relationship("VoteParticipation", back_populates="vote")

class VoteParticipation(Base):
    __tablename__ = "vote_participations"

    id = Column(Integer, primary_key=True, index=True)
    vote_id = Column(Integer, ForeignKey("votes.id"))
    user_id = Column(Integer, ForeignKey("users.id"))
    selected_option = Column(String(100))
    voted_at = Column(DateTime(timezone=True), server_default=func.now())

    vote = relationship("Vote", back_populates="participations")

class SystemAnnouncement(Base):
    __tablename__ = "system_announcements"
    
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String(255), nullable=False)
    content = Column(Text, nullable=False)
    target_complex = Column(String(100), default="ALL") # "ALL" or specific complex name
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    is_active = Column(Boolean, default=True)

# --- Fintech Extension (GreenPay) ---
class Wallet(Base):
    __tablename__ = "wallets"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), unique=True)
    balance = Column(Numeric(12, 2), default=0.00)
    currency = Column(String(10), default="KRW")
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())

    user = relationship("User", backref="wallet")
    transactions = relationship("Transaction", back_populates="wallet")

class Transaction(Base):
    __tablename__ = "transactions"

    id = Column(Integer, primary_key=True, index=True)
    wallet_id = Column(Integer, ForeignKey("wallets.id"))
    amount = Column(Numeric(12, 2), nullable=False)
    type = Column(String(20), nullable=False) # CHARGE, PAYMENT, REFUND
    description = Column(String(255))
    status = Column(String(20), default="COMPLETED") # PENDING, COMPLETED, FAILED
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    wallet = relationship("Wallet", back_populates="transactions")

# --- New Content Extensions ---
class EnergyChallenge(Base):
    __tablename__ = "energy_challenges"
    
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String(255), nullable=False)
    description = Column(Text)
    start_date = Column(DateTime(timezone=True), nullable=False)
    end_date = Column(DateTime(timezone=True), nullable=False)
    goal_percent = Column(Integer, default=10) # Target % reduction
    reward_points = Column(Integer, default=1000)
    is_active = Column(Boolean, default=True)

class UserChallengeStatus(Base):
    __tablename__ = "user_challenge_status"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    challenge_id = Column(Integer, ForeignKey("energy_challenges.id"))
    current_savings = Column(Numeric(5, 2), default=0.00)
    is_completed = Column(Boolean, default=False)
    joined_at = Column(DateTime(timezone=True), server_default=func.now())

class EVCharger(Base):
    __tablename__ = "ev_chargers"
    
    id = Column(Integer, primary_key=True, index=True)
    complex_name = Column(String(100), nullable=False)
    location = Column(String(100)) # e.g. "B1 Section A"
    status = Column(String(20), default="AVAILABLE") # AVAILABLE, CHARGING, ERROR
    current_user_id = Column(Integer, ForeignKey("users.id"), nullable=True)

class Delivery(Base):
    __tablename__ = "deliveries"
    
    id = Column(Integer, primary_key=True, index=True)
    user_apartment_id = Column(Integer, ForeignKey("user_apartments.id"))
    courier = Column(String(50))
    tracking_number = Column(String(100))
    status = Column(String(20), default="ARRIVED") # ARRIVED, PICKED_UP
    arrived_at = Column(DateTime(timezone=True), server_default=func.now())
    picked_up_at = Column(DateTime(timezone=True))

class GreenShareItem(Base):
    __tablename__ = "green_share_items"
    
    id = Column(Integer, primary_key=True, index=True)
    author_id = Column(Integer, ForeignKey("users.id"))
    title = Column(String(255), nullable=False)
    description = Column(Text)
    category = Column(String(50)) # Tool, Leisure, Electronics, etc.
    price_points = Column(Integer, default=0) # 0 for free/sharing
    status = Column(String(20), default="AVAILABLE") # AVAILABLE, RESERVED, COMPLETED
    created_at = Column(DateTime(timezone=True), server_default=func.now())

class IoTDevice(Base):
    __tablename__ = "iot_devices"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    device_name = Column(String(100), nullable=False)
    device_type = Column(String(50)) # LIGHT, AC, TV, SENSOR, etc.
    provider_name = Column(String(50)) # SAMSUNG, LG, PHILIPS, MOCK, etc.
    
    # Flexible configuration for different manufacturers (Token, ClientID, etc.)
    connection_config = Column(JSON) 
    
    is_active = Column(Boolean, default=True)
    last_seen = Column(DateTime(timezone=True))
    created_at = Column(DateTime(timezone=True), server_default=func.now())

class IoTScenario(Base):
    __tablename__ = "iot_scenarios"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    name = Column(String(100), nullable=False) # e.g. "Coming Home", "Movie Night"
    icon = Column(String(50)) # Icon identifier
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    actions = relationship("IoTScenarioAction", back_populates="scenario", cascade="all, delete-orphan")

class IoTScenarioAction(Base):
    __tablename__ = "iot_scenario_actions"
    
    id = Column(Integer, primary_key=True, index=True)
    scenario_id = Column(Integer, ForeignKey("iot_scenarios.id"))
    device_id = Column(Integer, ForeignKey("iot_devices.id"))
    
    # Target state (e.g. {"power": "ON", "brightness": 80, "temp": 24})
    target_state = Column(JSON, nullable=False) 

    scenario = relationship("IoTScenario", back_populates="actions")

class ConciergeSuggestion(Base):
    __tablename__ = "concierge_suggestions"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    title = Column(String(255), nullable=False)
    description = Column(Text)
    type = Column(String(50)) # IoT_MAINTENANCE, SERVICE_RESERVATION, INFO
    action_label = Column(String(50)) # e.g. "Order Filter", "Book Service"
    action_url = Column(String(255))
    is_read = Column(Boolean, default=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

# 1. Green Exchange: Talent & Time
class TalentExchange(Base):
    __tablename__ = "talent_exchanges"
    
    id = Column(Integer, primary_key=True, index=True)
    provider_id = Column(Integer, ForeignKey("users.id"))
    title = Column(String(100), nullable=False)
    description = Column(Text)
    category = Column(String(50)) # TUTORING, MAINTENANCE, PET_CARE, etc.
    price_gp = Column(Integer, default=0)
    estimated_time = Column(String(50)) # e.g. "30 mins", "1 hour"
    status = Column(String(20), default="AVAILABLE") # AVAILABLE, PENDING, COMPLETED
    created_at = Column(DateTime(timezone=True), server_default=func.now())

# 2. Hyper-local Social Club
class SocialClub(Base):
    __tablename__ = "social_clubs"
    
    id = Column(Integer, primary_key=True, index=True)
    founder_id = Column(Integer, ForeignKey("users.id"))
    name = Column(String(100), nullable=False)
    description = Column(Text)
    category = Column(String(50)) # SPORTS, HOBBY, STUDY, WINE, etc.
    image_url = Column(String(255))
    created_at = Column(DateTime(timezone=True), server_default=func.now())

class ClubEvent(Base):
    __tablename__ = "club_events"
    
    id = Column(Integer, primary_key=True, index=True)
    club_id = Column(Integer, ForeignKey("social_clubs.id"))
    title = Column(String(100), nullable=False)
    event_date = Column(DateTime)
    facility_id = Column(Integer, ForeignKey("facilities.id"), nullable=True) # Linked to facility booking
    max_participants = Column(Integer)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

# 3. Empty House Premium Care
class HomeCareRequest(Base):
    __tablename__ = "home_care_requests"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    start_date = Column(Date, nullable=False)
    end_date = Column(Date, nullable=False)
    care_types = Column(JSON) # ["MAIL", "PLANTS", "SECURITY", "PETS"]
    notes = Column(Text)
    status = Column(String(20), default="REQUESTED") # REQUESTED, ACTIVE, COMPLETED
    created_at = Column(DateTime(timezone=True), server_default=func.now())

# --- Home Infrastructure (Pre-installed by Construction Co.) ---
class HomeEquipment(Base):
    __tablename__ = "home_equipments"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    equipment_type = Column(String(50)) # WALLPAD, DOORLOCK, LIGHT_SWITCH, THERMOSTAT, GAS_VALVE
    equipment_name = Column(String(100)) # e.g. "Main Wallpad", "Entrance Doorlock"
    manufacturer = Column(String(50)) # e.g. "COMMAX", "HYUNDAI_HT", "YALE"
    firmware_version = Column(String(50))
    connection_status = Column(String(20), default="ONLINE") # ONLINE, OFFLINE, ERROR
    current_state = Column(JSON) # e.g. {"power": "ON", "temp": 24, "locked": true}
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

