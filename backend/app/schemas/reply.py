from pydantic import BaseModel, Field, ConfigDict
from typing import Optional, List
from datetime import datetime
from uuid import UUID


class ReplyCreateRequest(BaseModel):
    youtubeUrl: str = Field(..., min_length=1, max_length=500)
    replyText: str = Field(..., min_length=1, max_length=5000)
    coverImageUrl: Optional[str] = Field(default=None, max_length=500)


class ReplyResponse(BaseModel):
    id: UUID
    cassetteId: UUID
    senderId: UUID

    youtubeUrl: str
    youtubeVideoId: str
    youtubeEmbedUrl: str
    title: Optional[str]
    thumbnailUrl: Optional[str]

    replyText: str
    coverImageUrl: Optional[str]

    senderName: Optional[str]

    createdAt: datetime
    updatedAt: datetime

    model_config = ConfigDict(from_attributes=True)


class ReplyListResponse(BaseModel):
    items: List[ReplyResponse]
    total: int