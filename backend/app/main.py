"""
FastAPI application for Digital Cassette backend.
"""

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Import routers
from app.api.routes import auth, cassettes, library, replies, inbox


# App metadata
APP_NAME = os.getenv("APP_NAME", "Digital Cassette")
APP_VERSION = os.getenv("APP_VERSION", "1.0.0")

# Create FastAPI app
app = FastAPI(
    title=APP_NAME,
    version=APP_VERSION,
    description="Backend API for Digital Cassette - YouTube song letters with emotional sharing"
)

# CORS configuration
allowed_origins = os.getenv(
    "ALLOWED_ORIGINS",
    "http://localhost:3000,http://127.0.0.1:3000,http://localhost:*,http://127.0.0.1:*"
).split(",")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all origins for development
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ----------------------------------------------------
# API ROUTES
# ----------------------------------------------------
app.include_router(auth.router, prefix="/api", tags=["Auth"])
app.include_router(cassettes.router, prefix="/api", tags=["Cassettes"])
app.include_router(library.router, prefix="/api", tags=["Library"])
app.include_router(replies.router, prefix="/api", tags=["Replies"])
app.include_router(inbox.router, prefix="/api", tags=["Inbox"])


# ----------------------------------------------------
# ROOT ENDPOINT
# ----------------------------------------------------

@app.get("/")
async def root():
    return {
        "app": APP_NAME,
        "version": APP_VERSION,
        "status": "running"
    }


# ----------------------------------------------------
# HEALTH CHECK
# ----------------------------------------------------

@app.get("/health")
async def health_check():
    return {"status": "healthy"}