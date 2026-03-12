"""
Pydantic schemas for Cassette endpoints.
Uses camelCase to match Flutter frontend.
"""
from pydantic import BaseModel, Field, field_validator, ConfigDict
from typing import Optional
from datetime import datetime
from uuid import UUID

from app.core.enums import EmotionTag


class CassetteCreateRequest(BaseModel):
    youtubeUrl: str = Field(..., min_length=1, max_length=500)
    letterText: str = Field(..., min_length=1, max_length=5000)
    emotionTag: EmotionTag
    senderIsAnonymous: bool = Field(default=False)
    password: str = Field(..., min_length=4, max_length=50)
    coverImageUrl: Optional[str] = Field(default=None, max_length=500)

    @field_validator("youtubeUrl")
    @classmethod
    def validate_youtube_url(cls, v):
        if not v or not v.strip():
            raise ValueError("YouTube URL is required")
        return v.strip()

    @field_validator("letterText")
    @classmethod
    def validate_letter_text(cls, v):
        if not v or not v.strip():
            raise ValueError("Letter text is required")
        return v.strip()

    @field_validator("password")
    @classmethod
    def validate_password(cls, v):
        if len(v) < 4:
            raise ValueError("Password must be at least 4 characters")
        return v

    model_config = ConfigDict(use_enum_values=True)


class CassetteResponse(BaseModel):
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


class CassetteCreateResponse(BaseModel):
    cassette: CassetteResponse
    message: str = "Cassette created successfully"

    model_config = ConfigDict(from_attributes=True)


class ShareCodeValidationResponse(BaseModel):
    isValid: bool
    cassette: Optional[CassetteResponse] = None
    validationResult: str
    errorMessage: Optional[str] = None

    model_config = ConfigDict(from_attributes=True)


class PasswordValidationRequest(BaseModel):
    password: str = Field(..., min_length=1)


class PasswordValidationResponse(BaseModel):
    isValid: bool
    attemptsRemaining: Optional[int] = None
    message: Optional[str] = None


class CassetteUnlockRequest(BaseModel):
    password: str = Field(..., min_length=1)


class CassetteUnlockResponse(BaseModel):
    letterText: str
    youtubeEmbedUrl: str
    emotionTag: str
    emotionEmoji: str