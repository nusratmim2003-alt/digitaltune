"""
Cassette model for Digital Cassette.
"""

from sqlalchemy import Column, String, DateTime, Boolean, Integer, ForeignKey, Text
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from datetime import datetime
import uuid

from app.db.base_class import Base


class Cassette(Base):
    __tablename__ = "cassettes"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)

    senderId = Column(
        "sender_id",
        UUID(as_uuid=True),
        ForeignKey("users.id"),
        nullable=False,
        index=True,
    )

    # Share code
    shareCode = Column("share_code", String(6), unique=True, nullable=False, index=True)
    shareUrl = Column("share_url", String(500), nullable=False)

    # YouTube data
    youtubeUrl = Column("youtube_url", String(500), nullable=False)
    youtubeVideoId = Column("youtube_video_id", String(11), nullable=False)
    youtubeEmbedUrl = Column("youtube_embed_url", String(500), nullable=False)
    title = Column(String(500), nullable=True)
    thumbnailUrl = Column("thumbnail_url", String(500), nullable=True)

    # Letter content
    letterText = Column("letter_text", Text, nullable=False)
    coverImageUrl = Column("cover_image_url", String(500), nullable=True)

    # Emotion
    emotionTag = Column("emotion_tag", String(50), nullable=False)
    emotionEmoji = Column("emotion_emoji", String(10), nullable=False)

    # Sender settings
    senderIsAnonymous = Column(
        "sender_is_anonymous",
        Boolean,
        default=False,
        nullable=False,
    )

    # Password protection
    passwordHash = Column("password_hash", String(255), nullable=False)

    # Status flags
    isActive = Column("is_active", Boolean, default=True, nullable=False)
    isDeleted = Column("is_deleted", Boolean, default=False, nullable=False)

    # Unlock tracking
    unlockCount = Column("unlock_count", Integer, default=0, nullable=False)

    # Timestamps
    createdAt = Column("created_at", DateTime, default=datetime.utcnow, nullable=False)
    updatedAt = Column(
        "updated_at",
        DateTime,
        default=datetime.utcnow,
        onupdate=datetime.utcnow,
        nullable=False,
    )

    # Relationships
    sender = relationship("User", back_populates="cassettes", foreign_keys=[senderId])
    savedBy = relationship("SavedCassette", back_populates="cassette", cascade="all, delete-orphan")
    replies = relationship("CassetteReply", back_populates="cassette", cascade="all, delete-orphan")
    def __repr__(self):
        return f"<Cassette {self.shareCode}>"