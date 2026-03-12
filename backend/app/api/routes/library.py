"""
Library endpoints for Digital Cassette.
"""

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from sqlalchemy import desc

from app.db.session import get_db
from app.models.user import User
from app.models.cassette import Cassette
from app.models.saved_cassette import SavedCassette
from app.api.deps import get_current_user
from app.schemas.library import (
    SaveCassetteResponse,
    LibraryCassetteItem,
    LibraryListResponse,
)

router = APIRouter()


@router.post("/library/save/{cassette_id}", response_model=SaveCassetteResponse)
def save_cassette(
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

    existing_save = (
        db.query(SavedCassette)
        .filter(
            SavedCassette.userId == current_user.id,
            SavedCassette.cassetteId == cassette.id,
        )
        .first()
    )

    if existing_save:
        return SaveCassetteResponse(
            message="Cassette already saved",
            cassetteId=cassette.id,
            saved=True,
        )

    saved = SavedCassette(
        userId=current_user.id,
        cassetteId=cassette.id,
    )

    db.add(saved)
    db.commit()

    return SaveCassetteResponse(
        message="Cassette saved successfully",
        cassetteId=cassette.id,
        saved=True,
    )


@router.delete("/library/save/{cassette_id}", response_model=SaveCassetteResponse)
def unsave_cassette(
    cassette_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    saved = (
        db.query(SavedCassette)
        .filter(
            SavedCassette.userId == current_user.id,
            SavedCassette.cassetteId == cassette_id,
        )
        .first()
    )

    if not saved:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Saved cassette not found",
        )

    db.delete(saved)
    db.commit()

    return SaveCassetteResponse(
        message="Cassette removed from saved library",
        cassetteId=saved.cassetteId,
        saved=False,
    )


@router.get("/library/saved", response_model=LibraryListResponse)
def get_saved_cassettes(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    saved_rows = (
        db.query(Cassette)
        .join(SavedCassette, SavedCassette.cassetteId == Cassette.id)
        .filter(SavedCassette.userId == current_user.id)
        .order_by(desc(SavedCassette.savedAt))
        .all()
    )

    items = [
        LibraryCassetteItem(
            id=row.id,
            shareCode=row.shareCode,
            shareUrl=row.shareUrl,
            youtubeUrl=row.youtubeUrl,
            youtubeVideoId=row.youtubeVideoId,
            youtubeEmbedUrl=row.youtubeEmbedUrl,
            title=row.title,
            thumbnailUrl=row.thumbnailUrl,
            letterText=row.letterText,
            coverImageUrl=row.coverImageUrl,
            emotionTag=row.emotionTag,
            emotionEmoji=row.emotionEmoji,
            senderName=None,
            senderIsAnonymous=row.senderIsAnonymous,
            isActive=row.isActive,
            isDeleted=row.isDeleted,
            unlockCount=row.unlockCount,
            createdAt=row.createdAt,
            updatedAt=row.updatedAt,
        )
        for row in saved_rows
    ]

    return LibraryListResponse(items=items, total=len(items))


@router.get("/library/sent", response_model=LibraryListResponse)
def get_sent_cassettes(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    rows = (
        db.query(Cassette)
        .filter(Cassette.senderId == current_user.id)
        .order_by(desc(Cassette.createdAt))
        .all()
    )

    items = [
        LibraryCassetteItem(
            id=row.id,
            shareCode=row.shareCode,
            shareUrl=row.shareUrl,
            youtubeUrl=row.youtubeUrl,
            youtubeVideoId=row.youtubeVideoId,
            youtubeEmbedUrl=row.youtubeEmbedUrl,
            title=row.title,
            thumbnailUrl=row.thumbnailUrl,
            letterText=row.letterText,
            coverImageUrl=row.coverImageUrl,
            emotionTag=row.emotionTag,
            emotionEmoji=row.emotionEmoji,
            senderName=None if row.senderIsAnonymous else current_user.name,
            senderIsAnonymous=row.senderIsAnonymous,
            isActive=row.isActive,
            isDeleted=row.isDeleted,
            unlockCount=row.unlockCount,
            createdAt=row.createdAt,
            updatedAt=row.updatedAt,
        )
        for row in rows
    ]

    return LibraryListResponse(items=items, total=len(items))