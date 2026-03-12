"""
SavedCassette model for Digital Cassette.
"""

from sqlalchemy import Column, DateTime, ForeignKey, UniqueConstraint
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from datetime import datetime
import uuid

from app.db.base_class import Base


class SavedCassette(Base):
    __tablename__ = "saved_cassettes"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)

    userId = Column(
        "user_id",
        UUID(as_uuid=True),
        ForeignKey("users.id"),
        nullable=False,
        index=True,
    )

    cassetteId = Column(
        "cassette_id",
        UUID(as_uuid=True),
        ForeignKey("cassettes.id"),
        nullable=False,
        index=True,
    )

    savedAt = Column("saved_at", DateTime, default=datetime.utcnow, nullable=False)

    user = relationship("User", back_populates="savedCassettes")
    cassette = relationship("Cassette", back_populates="savedBy")

    __table_args__ = (
        UniqueConstraint("user_id", "cassette_id", name="uq_saved_cassettes_user_cassette"),
    )

    def __repr__(self):
        return f"<SavedCassette user={self.userId} cassette={self.cassetteId}>"