from pydantic import BaseModel, EmailStr, Field, ConfigDict
from datetime import datetime
from uuid import UUID


class RegisterRequest(BaseModel):
    name: str = Field(..., min_length=1, max_length=255)
    email: EmailStr
    password: str = Field(..., min_length=4, max_length=100)


class LoginRequest(BaseModel):
    email: EmailStr
    password: str


class GoogleLoginRequest(BaseModel):
    idToken: str = Field(..., description="Google ID token from client")


class TokenResponse(BaseModel):
    accessToken: str
    tokenType: str = "bearer"


class UserResponse(BaseModel):
    id: UUID
    name: str
    email: EmailStr
    createdAt: datetime

    model_config = ConfigDict(from_attributes=True)