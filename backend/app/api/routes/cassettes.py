"""
Cassette endpoints for Digital Cassette.
"""

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from passlib.context import CryptContext
import os

from app.db.session import get_db
from app.models.user import User
from app.models.cassette import Cassette
from app.schemas.cassette import (
    CassetteCreateRequest,
    CassetteCreateResponse,
    CassetteResponse,
    CassetteUnlockRequest,
    CassetteUnlockResponse,
)
from app.api.deps import get_current_user
from app.utils.youtube import parse_youtube_url, YouTubeURLError
from app.utils.share_code import generate_unique_share_code
from app.core.enums import EmotionTag

router = APIRouter()

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
# Temporarily hardcoded for development - change in production
FRONTEND_URL = os.getenv("FRONTEND_URL", "http://localhost:53925")

EMOTION_EMOJI_MAP = {
    EmotionTag.JOYFUL: "😊",
    EmotionTag.MELANCHOLIC: "😢",
    EmotionTag.NOSTALGIC: "🌅",
    EmotionTag.HOPEFUL: "🌟",
    EmotionTag.ROMANTIC: "💕",
    EmotionTag.BITTERSWEET: "🥲",
    EmotionTag.PEACEFUL: "🕊️",
    EmotionTag.ENERGETIC: "⚡",
}


@router.post(
    "/cassettes",
    response_model=CassetteCreateResponse,
    status_code=status.HTTP_201_CREATED,
)
async def create_cassette(
    data: CassetteCreateRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    try:
        youtube_data = parse_youtube_url(data.youtubeUrl)
    except YouTubeURLError as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e),
        )

    try:
        share_code = generate_unique_share_code(db, Cassette)
    except RuntimeError:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Could not generate share code",
        )

    share_url = f"{FRONTEND_URL}/unlock/{share_code}"
    password_hash = pwd_context.hash(data.password)
    emotion_emoji = EMOTION_EMOJI_MAP.get(data.emotionTag, "🎵")

    cassette = Cassette(
        senderId=current_user.id,
        shareCode=share_code,
        shareUrl=share_url,
        youtubeUrl=youtube_data.original_url,
        youtubeVideoId=youtube_data.video_id,
        youtubeEmbedUrl=youtube_data.embed_url,
        thumbnailUrl=youtube_data.thumbnail_url,
        letterText=data.letterText,
        coverImageUrl=data.coverImageUrl,
        emotionTag=data.emotionTag.value if hasattr(data.emotionTag, "value") else data.emotionTag,
        emotionEmoji=emotion_emoji,
        senderIsAnonymous=data.senderIsAnonymous,
        passwordHash=password_hash,
        isActive=True,
        isDeleted=False,
        unlockCount=0,
    )

    db.add(cassette)
    db.commit()
    db.refresh(cassette)

    cassette_response = CassetteResponse(
        id=cassette.id,
        shareCode=cassette.shareCode,
        shareUrl=cassette.shareUrl,
        youtubeUrl=cassette.youtubeUrl,
        youtubeVideoId=cassette.youtubeVideoId,
        youtubeEmbedUrl=cassette.youtubeEmbedUrl,
        title=getattr(cassette, "title", None),
        thumbnailUrl=cassette.thumbnailUrl,
        letterText=cassette.letterText,
        coverImageUrl=cassette.coverImageUrl,
        emotionTag=cassette.emotionTag,
        emotionEmoji=cassette.emotionEmoji,
        senderName=None if cassette.senderIsAnonymous else current_user.name,
        senderIsAnonymous=cassette.senderIsAnonymous,
        isActive=cassette.isActive,
        isDeleted=cassette.isDeleted,
        unlockCount=cassette.unlockCount,
        createdAt=cassette.createdAt,
        updatedAt=cassette.updatedAt,
    )

    return CassetteCreateResponse(
        cassette=cassette_response,
        message="Cassette created successfully",
    )


@router.get("/cassettes/{share_code}")
async def get_cassette_metadata(
    share_code: str,
    db: Session = Depends(get_db),
):
    cassette = db.query(Cassette).filter(Cassette.shareCode == share_code).first()

    if not cassette:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Cassette not found",
        )

    return {
        "id": str(cassette.id),
        "shareCode": cassette.shareCode,
        "youtubeEmbedUrl": cassette.youtubeEmbedUrl,
        "thumbnailUrl": cassette.thumbnailUrl,
        "emotionTag": cassette.emotionTag,
        "emotionEmoji": cassette.emotionEmoji,
        "senderIsAnonymous": cassette.senderIsAnonymous,
        "unlockCount": cassette.unlockCount,
        "locked": True,
    }


@router.post(
    "/cassettes/{share_code}/unlock",
    response_model=CassetteUnlockResponse,
)
async def unlock_cassette(
    share_code: str,
    data: CassetteUnlockRequest,
    db: Session = Depends(get_db),
):
    cassette = db.query(Cassette).filter(Cassette.shareCode == share_code).first()

    if not cassette:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Cassette not found",
        )

    if not pwd_context.verify(data.password, cassette.passwordHash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect password",
        )

    cassette.unlockCount += 1
    db.commit()

    return CassetteUnlockResponse(
        letterText=cassette.letterText,
        youtubeEmbedUrl=cassette.youtubeEmbedUrl,
        emotionTag=cassette.emotionTag,
        emotionEmoji=cassette.emotionEmoji,
    )


@router.get("/cassettes/by-id/{cassette_id}", response_model=CassetteResponse)
async def get_cassette_by_id(
    cassette_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Get full cassette details by ID (UUID)"""
    cassette = db.query(Cassette).filter(Cassette.id == cassette_id).first()

    if not cassette:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Cassette not found",
        )

    # Get sender info
    sender_name = None
    if not cassette.senderIsAnonymous and cassette.sender:
        sender_name = cassette.sender.name

    return CassetteResponse(
        id=cassette.id,
        shareCode=cassette.shareCode,
        shareUrl=cassette.shareUrl,
        youtubeUrl=cassette.youtubeUrl,
        youtubeVideoId=cassette.youtubeVideoId,
        youtubeEmbedUrl=cassette.youtubeEmbedUrl,
        title=getattr(cassette, "title", None),
        thumbnailUrl=cassette.thumbnailUrl,
        letterText=cassette.letterText,
        coverImageUrl=cassette.coverImageUrl,
        emotionTag=cassette.emotionTag,
        emotionEmoji=cassette.emotionEmoji,
        senderName=sender_name,
        senderIsAnonymous=cassette.senderIsAnonymous,
        isActive=cassette.isActive,
        isDeleted=cassette.isDeleted,
        unlockCount=cassette.unlockCount,
        createdAt=cassette.createdAt,
        updatedAt=cassette.updatedAt,
    )