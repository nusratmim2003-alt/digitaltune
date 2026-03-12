"""
CassetteReply model for Digital Cassette.
"""

from sqlalchemy import Column, String, DateTime, ForeignKey, Text
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from datetime import datetime
import uuid

from app.db.base_class import Base


class CassetteReply(Base):
    __tablename__ = "cassette_replies"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)

    cassetteId = Column(
        "cassette_id",
        UUID(as_uuid=True),
        ForeignKey("cassettes.id"),
        nullable=False,
        index=True,
    )

    senderId = Column(
        "sender_id",
        UUID(as_uuid=True),
        ForeignKey("users.id"),
        nullable=False,
        index=True,
    )

    youtubeUrl = Column("youtube_url", String(500), nullable=False)
    youtubeVideoId = Column("youtube_video_id", String(11), nullable=False)
    youtubeEmbedUrl = Column("youtube_embed_url", String(500), nullable=False)
    title = Column(String(500), nullable=True)
    thumbnailUrl = Column("thumbnail_url", String(500), nullable=True)

    replyText = Column("reply_text", Text, nullable=False)
    coverImageUrl = Column("cover_image_url", String(500), nullable=True)

    createdAt = Column("created_at", DateTime, default=datetime.utcnow, nullable=False)
    updatedAt = Column(
        "updated_at",
        DateTime,
        default=datetime.utcnow,
        onupdate=datetime.utcnow,
        nullable=False,
    )

    cassette = relationship("Cassette", back_populates="replies")
    sender = relationship("User", back_populates="cassetteReplies")

    def __repr__(self):
        return f"<CassetteReply cassette={self.cassetteId} sender={self.senderId}>"