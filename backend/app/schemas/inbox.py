from pydantic import BaseModel, ConfigDict
from typing import List, Optional
from datetime import datetime
from uuid import UUID


class InboxItem(BaseModel):
    cassetteId: UUID
    shareCode: str
    thumbnailUrl: Optional[str]
    emotionTag: str
    emotionEmoji: str
    latestReplyText: Optional[str]
    latestReplyAt: datetime
    latestReplySenderName: Optional[str]

    model_config = ConfigDict(from_attributes=True)


class InboxListResponse(BaseModel):
    items: List[InboxItem]
    total: int