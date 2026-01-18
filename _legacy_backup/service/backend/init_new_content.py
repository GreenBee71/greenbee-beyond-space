import asyncio
from sqlalchemy.ext.asyncio import create_async_engine
from sqlalchemy import text
import os
import urllib.parse

# Load DB Pass from Env
DB_PASS = os.getenv("POSTGRES_PASSWORD", "greenbee_pass")
encoded_pass = urllib.parse.quote_plus(DB_PASS)
DB_HOST = os.getenv("DB_HOST", "db")
DB_NAME = os.getenv("POSTGRES_DB", "greenbee_beyond_space.db")
DB_USER = os.getenv("POSTGRES_USER", "greenbee")

DATABASE_URL = f"postgresql+asyncpg://{DB_USER}:{encoded_pass}@{DB_HOST}:5432/{DB_NAME}"

engine = create_async_engine(DATABASE_URL)

async def init_new_content():
    async with engine.begin() as conn:
        # 1. Create Tables
        tables = [
            """
            CREATE TABLE IF NOT EXISTS energy_challenges (
                id SERIAL PRIMARY KEY,
                title VARCHAR(255) NOT NULL,
                description TEXT,
                start_date TIMESTAMP WITH TIME ZONE NOT NULL,
                end_date TIMESTAMP WITH TIME ZONE NOT NULL,
                goal_percent INTEGER DEFAULT 10,
                reward_points INTEGER DEFAULT 1000,
                is_active BOOLEAN DEFAULT TRUE
            );
            """,
            """
            CREATE TABLE IF NOT EXISTS ev_chargers (
                id SERIAL PRIMARY KEY,
                complex_name VARCHAR(100) NOT NULL,
                location VARCHAR(100),
                status VARCHAR(20) DEFAULT 'AVAILABLE',
                current_user_id INTEGER
            );
            """,
            """
            CREATE TABLE IF NOT EXISTS deliveries (
                id SERIAL PRIMARY KEY,
                user_apartment_id INTEGER,
                courier VARCHAR(50),
                tracking_number VARCHAR(100),
                status VARCHAR(20) DEFAULT 'ARRIVED',
                arrived_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
                picked_up_at TIMESTAMP WITH TIME ZONE
            );
            """,
            """
            CREATE TABLE IF NOT EXISTS facilities (
                id SERIAL PRIMARY KEY,
                complex_name VARCHAR(100) NOT NULL,
                name VARCHAR(50) NOT NULL,
                capacity INTEGER DEFAULT 10,
                is_active BOOLEAN DEFAULT TRUE
            );
            """,
            """
            CREATE TABLE IF NOT EXISTS visitors (
                id SERIAL PRIMARY KEY,
                user_apartment_id INTEGER,
                car_number VARCHAR(20) NOT NULL,
                visitor_name VARCHAR(50),
                visit_date DATE NOT NULL,
                purpose VARCHAR(100),
                status VARCHAR(20) DEFAULT 'PENDING',
                created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
            );
            """,
            """
            CREATE TABLE IF NOT EXISTS green_share_items (
                id SERIAL PRIMARY KEY,
                author_id INTEGER,
                title VARCHAR(255) NOT NULL,
                description TEXT,
                category VARCHAR(50),
                price_points INTEGER DEFAULT 0,
                status VARCHAR(20) DEFAULT 'AVAILABLE',
                created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
            );
            """,
            """
            CREATE TABLE IF NOT EXISTS talent_exchanges (
                id SERIAL PRIMARY KEY,
                provider_id INTEGER,
                title VARCHAR(255) NOT NULL,
                description TEXT,
                category VARCHAR(50),
                price_points INTEGER DEFAULT 0,
                estimated_time VARCHAR(50),
                status VARCHAR(20) DEFAULT 'AVAILABLE',
                created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
            );
            """,
            """
            CREATE TABLE IF NOT EXISTS social_clubs (
                id SERIAL PRIMARY KEY,
                founder_id INTEGER,
                name VARCHAR(255) NOT NULL,
                description TEXT,
                category VARCHAR(50),
                image_url VARCHAR(255),
                created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
            );
            """,
            """
            CREATE TABLE IF NOT EXISTS home_care_requests (
                id SERIAL PRIMARY KEY,
                user_id INTEGER,
                start_date DATE NOT NULL,
                end_date DATE NOT NULL,
                care_types JSONB,
                notes TEXT,
                status VARCHAR(20) DEFAULT 'REQUESTED',
                created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
            );
            """
        ]
        for tbl in tables:
            await conn.execute(text(tbl))
        
        # 2. Add Mock Data
        mocks = [
            "INSERT INTO energy_challenges (title, description, start_date, end_date, goal_percent, reward_points) VALUES ('1월 에너지 다이어트', '전월 대비 전기 사용량 10% 절감 시 2,000P 지급!', '2026-01-01', '2026-01-31', 10, 2000) ON CONFLICT DO NOTHING;",
            "INSERT INTO ev_chargers (complex_name, location, status) VALUES ('그린비 자이', '지하 1층 A구역 #1', 'AVAILABLE') ON CONFLICT DO NOTHING;",
            "INSERT INTO ev_chargers (complex_name, location, status) VALUES ('그린비 자이', '지하 1층 A구역 #2', 'CHARGING') ON CONFLICT DO NOTHING;",
            "INSERT INTO deliveries (user_apartment_id, courier, tracking_number, status) VALUES (1, 'CJ대한통운', '123-456-789', 'ARRIVED') ON CONFLICT DO NOTHING;",
            "INSERT INTO deliveries (user_apartment_id, courier, tracking_number, status) VALUES (1, '그린 세탁', 'LAUNDRY-001', 'PICKED_UP') ON CONFLICT DO NOTHING;",
            "INSERT INTO facilities (complex_name, name, capacity, is_active) VALUES ('그린비 자이', '커뮤니티 헬스장', 50, TRUE) ON CONFLICT DO NOTHING;",
            "INSERT INTO facilities (complex_name, name, capacity, is_active) VALUES ('그린비 자이', '실내 골프장', 10, TRUE) ON CONFLICT DO NOTHING;",
            "INSERT INTO visitors (user_apartment_id, car_number, visitor_name, visit_date, purpose, status) VALUES (1, '12가 3456', '홍길동(지인)', '2026-01-09', '방문', 'APPROVED') ON CONFLICT DO NOTHING;",
            "INSERT INTO green_share_items (author_id, title, category, price_points, status) VALUES (1, '전동 드릴 빌려드려요', '공구', 0, 'AVAILABLE') ON CONFLICT DO NOTHING;",
            "INSERT INTO green_share_items (author_id, title, category, price_points, status) VALUES (1, '아이패드 거치대', '전자', 5000, 'AVAILABLE') ON CONFLICT DO NOTHING;",
            "INSERT INTO talent_exchanges (provider_id, title, category, price_points, estimated_time, status) VALUES (2, '이케아 가구 조립 도와드려요', 'MAINTENANCE', 500, '1시간', 'AVAILABLE') ON CONFLICT DO NOTHING;",
            "INSERT INTO talent_exchanges (provider_id, title, category, price_points, estimated_time, status) VALUES (3, '초등 수학 숙제 같이해요', 'TUTORING', 300, '30분', 'AVAILABLE') ON CONFLICT DO NOTHING;",
            "INSERT INTO social_clubs (founder_id, name, category, description) VALUES (1, '나이트 테니스 크루', 'SPORTS', '매주 화요일 저녁 9시 테니스 한판!') ON CONFLICT DO NOTHING;",
            "INSERT INTO social_clubs (founder_id, name, category, description) VALUES (2, '싱글몰트 테이스팅', 'WINE', '라운지에서 즐기는 위스키 한잔의 여유.') ON CONFLICT DO NOTHING;"
        ]
        for mock in mocks:
            await conn.execute(text(mock))
        
        print("Successfully initialized all new content tables and mock data.")

if __name__ == "__main__":
    asyncio.run(init_new_content())
