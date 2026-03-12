"""
Reply endpoints for Digital Cassette.
"""

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from sqlalchemy import desc

from app.db.session import get_db
from app.models.user import User
from app.models.cassette import Cassette
from app.models.cassette_reply import CassetteReply
from app.api.deps import get_current_user
from app.schemas.reply import ReplyCreateRequest, ReplyResponse, ReplyListResponse
from app.utils.youtube import parse_youtube_url, YouTubeURLError

router = APIRouter()


@router.post("/replies/{cassette_id}", response_model=ReplyResponse, status_code=status.HTTP_201_CREATED)
def create_reply(
    cassette_id: str,
    data: ReplyCreateRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    cassette = db.query(Cassette).filter(Cassette.id == cassette_id).first()

    if not cassette:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Cassette not found",
        )

    try:
        youtube_data = parse_youtube_url(data.youtubeUrl)
    except YouTubeURLError as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e),
        )

    reply = CassetteReply(
        cassetteId=cassette.id,
        senderId=current_user.id,
        youtubeUrl=youtube_data.original_url,
        youtubeVideoId=youtube_data.video_id,
        youtubeEmbedUrl=youtube_data.embed_url,
        title=None,
        thumbnailUrl=youtube_data.thumbnail_url,
        replyText=data.replyText,
        coverImageUrl=data.coverImageUrl,
    )

    db.add(reply)
    db.commit()
    db.refresh(reply)

    return ReplyResponse(
        id=reply.id,
        cassetteId=reply.cassetteId,
        senderId=reply.senderId,
        youtubeUrl=reply.youtubeUrl,
        youtubeVideoId=reply.youtubeVideoId,
        youtubeEmbedUrl=reply.youtubeEmbedUrl,
        title=reply.title,
        thumbnailUrl=reply.thumbnailUrl,
        replyText=reply.replyText,
        coverImageUrl=reply.coverImageUrl,
        senderName=current_user.name,
        createdAt=reply.createdAt,
        updatedAt=reply.updatedAt,
    )


@router.get("/replies/{cassette_id}", response_model=ReplyListResponse)
def list_replies(
    cassette_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    cassette = db.query(Cassette).filter(Cassette.id == cassette_id).first()

    if not cassette:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Cassette not found",
        )

    rows = (
        db.query(CassetteReply)
        .filter(CassetteReply.cassetteId == cassette.id)
        .order_by(desc(CassetteReply.createdAt))
        .all()
    )

    items = [
        ReplyResponse(
            id=row.id,
            cassetteId=row.cassetteId,
            senderId=row.senderId,
            youtubeUrl=row.youtubeUrl,
            youtubeVideoId=row.youtubeVideoId,
            youtubeEmbedUrl=row.youtubeEmbedUrl,
            title=row.title,
            thumbnailUrl=row.thumbnailUrl,
            replyText=row.replyText,
            coverImageUrl=row.coverImageUrl,
            senderName=row.sender.name if row.sender else None,
            createdAt=row.createdAt,
            updatedAt=row.updatedAt,
        )
        for row in rows
    ]

    return ReplyListResponse(items=items, total=len(items))