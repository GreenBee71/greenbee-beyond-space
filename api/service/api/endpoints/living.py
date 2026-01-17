from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy import desc
from typing import List

from ...db.database import get_db
from ...models.models import Visitor, Vote, CommunityPost, PostEmbedding, GreenShareItem, TalentExchange, SocialClub, HomeCareRequest
from ...schemas.resident import (
    VisitorCreate, VisitorRead, VoteRead, SearchRequest, SearchResult, GreenShareItemRead,
    TalentExchangeRead, SocialClubRead, HomeCareRequestCreate, HomeCareRequestRead
)

import numpy as np

router = APIRouter()

@router.get("/visitors", response_model=List[VisitorRead])
async def get_visitors(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Visitor).order_by(desc(Visitor.visit_date)))
    return result.scalars().all()

@router.post("/visitors", response_model=VisitorRead)
async def create_visitor(visitor: VisitorCreate, db: AsyncSession = Depends(get_db)):
    new_visitor = Visitor(
        user_apartment_id=1, 
        car_number=visitor.car_number,
        visitor_name=visitor.visitor_name,
        visit_date=visitor.visit_date,
        purpose=visitor.purpose,
        status="PENDING"
    )
    db.add(new_visitor)
    await db.commit()
    await db.refresh(new_visitor)
    return new_visitor

@router.get("/votes", response_model=List[VoteRead])
async def get_votes(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Vote).where(Vote.is_active == True))
    return result.scalars().all()

def mock_get_embedding(text: str):
    """
    Mock embedding generator for Phase 1.
    In production, this would call OpenAI or a local LLM.
    """
    # Deterministic mock vector based on string hash
    np.random.seed(hash(text) % 2**32)
    return np.random.rand(1536).tolist()

@router.get("/search", response_model=List[SearchResult])
async def search_community(query: str, db: AsyncSession = Depends(get_db)):
    """
    AI Semantic Search across community posts and notices.
    Uses pgvector for similarity ranking.
    """
    query_vector = mock_get_embedding(query)
    
    # Simple semantic search using l2_distance
    # In a real app, we'd use .l2_distance(query_vector)
    # For this demo, we'll fetch posts and simulate the ranking 
    # if the DB driver doesn't support the operator directly in this env.
    result = await db.execute(select(CommunityPost))
    posts = result.scalars().all()
    
    search_results = []
    for post in posts:
        # Mocking the score for now
        # Ideally: score = 1 / (1 + distance)
        score = 0.85 if query.lower() in post.title.lower() else 0.42
        
        search_results.append(SearchResult(
            id=post.id,
            title=post.title,
            content=post.content[:100] + "...",
            category=post.category,
            score=score
        ))
    
    # Sort by score
    search_results.sort(key=lambda x: x.score, reverse=True)
    return search_results[:5]

# --- New Content Endpoints ---
from ...models.models import EnergyChallenge, UserChallengeStatus, EVCharger, Delivery, Facility
from ...schemas.resident import EnergyChallengeRead, UserChallengeStatusRead, EVChargerRead, DeliveryRead, FacilityRead

@router.get("/challenges", response_model=List[EnergyChallengeRead])
async def get_challenges(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(EnergyChallenge).where(EnergyChallenge.is_active == True))
    return result.scalars().all()

@router.get("/ev-chargers", response_model=List[EVChargerRead])
async def get_ev_chargers(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(EVCharger))
    return result.scalars().all()

@router.get("/facilities", response_model=List[FacilityRead])
async def get_facilities(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Facility))
    return result.scalars().all()

@router.get("/deliveries", response_model=List[DeliveryRead])
async def get_deliveries(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Delivery).order_by(desc(Delivery.arrived_at)))
    return result.scalars().all()

@router.get("/share-items", response_model=List[GreenShareItemRead])
async def get_share_items(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(GreenShareItem).order_by(desc(GreenShareItem.created_at)))
    return result.scalars().all()

@router.get("/talent-exchanges", response_model=List[TalentExchangeRead])
async def get_talent_exchanges(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(TalentExchange).where(TalentExchange.status == "AVAILABLE"))
    return result.scalars().all()

@router.get("/social-clubs", response_model=List[SocialClubRead])
async def get_social_clubs(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(SocialClub))
    return result.scalars().all()

@router.post("/home-care", response_model=HomeCareRequestRead)
async def create_home_care_request(request: HomeCareRequestCreate, db: AsyncSession = Depends(get_db)):
    new_request = HomeCareRequest(
        user_id=1,
        start_date=request.start_date,
        end_date=request.end_date,
        care_types=request.care_types,
        notes=request.notes
    )
    db.add(new_request)
    await db.commit()
    await db.refresh(new_request)
    return new_request
