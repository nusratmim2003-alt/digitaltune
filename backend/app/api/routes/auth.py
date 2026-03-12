"""
Authentication endpoints for Digital Cassette.
"""

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from passlib.context import CryptContext
from google.auth.transport import requests
from google.oauth2 import id_token

from app.db.session import get_db
from app.models.user import User
from app.schemas.auth import RegisterRequest, LoginRequest, GoogleLoginRequest, TokenResponse, UserResponse
from app.api.deps import create_access_token, get_current_user
import os

router = APIRouter()

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


@router.post("/auth/register", response_model=UserResponse, status_code=status.HTTP_201_CREATED)
def register(
    data: RegisterRequest,
    db: Session = Depends(get_db),
):
    """Register a new user."""

    existing_user = db.query(User).filter(User.email == data.email).first()

    if existing_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email already registered",
        )

    user = User(
        name=data.name,
        email=data.email,
        passwordHash=pwd_context.hash(data.password),
    )

    db.add(user)
    db.commit()
    db.refresh(user)

    return user


@router.post("/auth/login", response_model=TokenResponse)
def login(
    data: LoginRequest,
    db: Session = Depends(get_db),
):
    """Login user and return JWT token."""

    user = db.query(User).filter(User.email == data.email).first()

    if not user or not pwd_context.verify(data.password, user.passwordHash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid email or password",
        )

    if not user.isActive:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="User account is inactive",
        )

    access_token = create_access_token({"sub": str(user.id)})

    return TokenResponse(
        accessToken=access_token,
        tokenType="bearer",
    )


@router.post("/auth/google", response_model=TokenResponse)
def google_login(
    data: GoogleLoginRequest,
    db: Session = Depends(get_db),
):
    """Login or register user via Google OAuth."""
    
    try:
        # Verify the Google ID token
        google_client_id = os.getenv("GOOGLE_CLIENT_ID")
        if not google_client_id:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail="Google OAuth not configured",
            )
        
        idinfo = id_token.verify_oauth2_token(
            data.idToken, 
            requests.Request(), 
            google_client_id
        )
        
        # Extract user info from Google token
        google_id = idinfo['sub']
        email = idinfo.get('email')
        name = idinfo.get('name', email.split('@')[0])
        picture = idinfo.get('picture')
        
        if not email:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Email not provided by Google",
            )
        
        # Check if user already exists with this Google ID
        user = db.query(User).filter(User.googleId == google_id).first()
        
        if not user:
            # Check if user exists with this email
            user = db.query(User).filter(User.email == email).first()
            
            if user:
                # Link existing email account to Google
                user.googleId = google_id
                user.authProvider = "google"
                if picture:
                    user.photoUrl = picture
            else:
                # Create new user
                user = User(
                    name=name,
                    email=email,
                    googleId=google_id,
                    authProvider="google",
                    photoUrl=picture,
                    passwordHash=None,  # No password for Google users
                    isVerified=True,  # Google emails are verified
                )
                db.add(user)
            
            db.commit()
            db.refresh(user)
        
        if not user.isActive:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="User account is inactive",
            )
        
        # Create access token
        access_token = create_access_token({"sub": str(user.id)})
        
        return TokenResponse(
            accessToken=access_token,
            tokenType="bearer",
        )
        
    except ValueError as e:
        # Invalid token
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=f"Invalid Google token: {str(e)}",
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Google authentication failed: {str(e)}",
        )


@router.get("/auth/me", response_model=UserResponse)
def me(current_user: User = Depends(get_current_user)):
    """Get current logged in user."""
    return current_user