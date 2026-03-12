from pydantic import BaseModel, ConfigDict
from typing import Optional, List
from datetime import datetime
from uuid import UUID


class LibraryCassetteItem(BaseModel):
    id: UUID
    shareCode: str
    shareUrl: str

    youtubeUrl: str
    youtubeVideoId: str
    youtubeEmbedUrl: str
    title: Optional[str]
    thumbnailUrl: Optional[str]

    letterText: str
    coverImageUrl: Optional[str]

    emotionTag: str
    emotionEmoji: str

    senderName: Optional[str]
    senderIsAnonymous: bool

    isActive: bool
    isDeleted: bool
    unlockCount: int

    createdAt: datetime
    updatedAt: datetime

    model_config = ConfigDict(from_attributes=True)


class SaveCassetteResponse(BaseModel):
    message: str
    cassetteId: UUID
    saved: bool


class LibraryListResponse(BaseModel):
    items: List[LibraryCassetteItem]
    total: int