"""
User model for Digital Cassette.
"""

from sqlalchemy import Column, String, DateTime, Boolean
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from datetime import datetime
import uuid

from app.db.base_class import Base


class User(Base):
    __tablename__ = "users"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)

    name = Column(String(255), nullable=False)

    email = Column(String(255), unique=True, nullable=False, index=True)

    passwordHash = Column("password_hash", String(255), nullable=True)
    
    # OAuth fields
    authProvider = Column("auth_provider", String(50), nullable=False, default="email")
    googleId = Column("google_id", String(255), nullable=True, unique=True, index=True)

    photoUrl = Column("photo_url", String(500), nullable=True)

    isActive = Column("is_active", Boolean, default=True, nullable=False)

    isVerified = Column("is_verified", Boolean, default=False, nullable=False)

    createdAt = Column("created_at", DateTime, default=datetime.utcnow, nullable=False)

    updatedAt = Column(
        "updated_at",
        DateTime,
        default=datetime.utcnow,
        onupdate=datetime.utcnow,
        nullable=False,
    )

    # --------------------------------------------------
    # Relationships
    # --------------------------------------------------

    # User -> Cassettes they created
    cassettes = relationship(
        "Cassette",
        back_populates="sender",
        foreign_keys="Cassette.senderId",
    )

    # User -> Saved cassette library
    savedCassettes = relationship(
        "SavedCassette",
        back_populates="user",
        cascade="all, delete-orphan",
    )
    cassetteReplies = relationship(
    "CassetteReply",
    back_populates="sender",
    cascade="all, delete-orphan",
    )
    def __repr__(self):
        return f"<User {self.email}>"