"""
YouTube URL processing utilities for Digital Cassette.
Handles pasted YouTube links and extracts video metadata.
"""

import re
from typing import Optional
from pydantic import BaseModel, validator


class YouTubeData(BaseModel):
    """Normalized YouTube data for storage."""
    video_id: str
    embed_url: str
    thumbnail_url: str
    original_url: str
    
    @validator('video_id')
    def validate_video_id(cls, v):
        if not v or len(v) != 11:
            raise ValueError('Invalid YouTube video ID')
        return v


class YouTubeURLError(Exception):
    """Raised when YouTube URL is invalid or unsupported."""
    pass


# Supported YouTube URL patterns
YOUTUBE_PATTERNS = [
    # Standard watch URL: https://www.youtube.com/watch?v=dQw4w9WgXcQ
    r'(?:https?:\/\/)?(?:www\.)?youtube\.com\/watch\?v=([a-zA-Z0-9_-]{11})',
    
    # Short URL: https://youtu.be/dQw4w9WgXcQ
    r'(?:https?:\/\/)?youtu\.be\/([a-zA-Z0-9_-]{11})',
    
    # Embed URL: https://www.youtube.com/embed/dQw4w9WgXcQ
    r'(?:https?:\/\/)?(?:www\.)?youtube\.com\/embed\/([a-zA-Z0-9_-]{11})',
    
    # Mobile URL: https://m.youtube.com/watch?v=dQw4w9WgXcQ
    r'(?:https?:\/\/)?m\.youtube\.com\/watch\?v=([a-zA-Z0-9_-]{11})',
    
    # YouTube Music: https://music.youtube.com/watch?v=dQw4w9WgXcQ
    r'(?:https?:\/\/)?music\.youtube\.com\/watch\?v=([a-zA-Z0-9_-]{11})',

    # Shorts URL: https://www.youtube.com/shorts/dQw4w9WgXcQ
    r'(?:https?:\/\/)?(?:www\.)?youtube\.com\/shorts\/([a-zA-Z0-9_-]{11})',
]


def extract_video_id(url: str) -> Optional[str]:
    """
    Extract YouTube video ID from various URL formats.
    
    Args:
        url: YouTube URL pasted by user
        
    Returns:
        11-character video ID or None if not found
        
    Examples:
        >>> extract_video_id('https://www.youtube.com/watch?v=dQw4w9WgXcQ')
        'dQw4w9WgXcQ'
        >>> extract_video_id('https://youtu.be/dQw4w9WgXcQ')
        'dQw4w9WgXcQ'
    """
    if not url or not isinstance(url, str):
        return None
    
    # Remove whitespace
    url = url.strip()
    
    # Try each pattern
    for pattern in YOUTUBE_PATTERNS:
        match = re.search(pattern, url)
        if match:
            video_id = match.group(1)
            # Validate video ID format (11 chars, alphanumeric + _ -)
            if len(video_id) == 11 and re.match(r'^[a-zA-Z0-9_-]{11}$', video_id):
                return video_id
    
    return None


def generate_embed_url(video_id: str) -> str:
    """
    Generate embeddable YouTube URL for iframe.
    
    Args:
        video_id: 11-character YouTube video ID
        
    Returns:
        Embed URL for iframe src
        
    Example:
        >>> generate_embed_url('dQw4w9WgXcQ')
        'https://www.youtube.com/embed/dQw4w9WgXcQ'
    """
    return f"https://www.youtube.com/embed/{video_id}"


def generate_thumbnail_url(video_id: str, quality: str = 'hqdefault') -> str:
    """
    Generate thumbnail URL from video ID.
    
    Args:
        video_id: 11-character YouTube video ID
        quality: Thumbnail quality
            - default: 120x90
            - mqdefault: 320x180
            - hqdefault: 480x360 (default)
            - sddefault: 640x480
            - maxresdefault: 1280x720 (not always available)
            
    Returns:
        Direct URL to thumbnail image
        
    Example:
        >>> generate_thumbnail_url('dQw4w9WgXcQ')
        'https://img.youtube.com/vi/dQw4w9WgXcQ/hqdefault.jpg'
    """
    return f"https://img.youtube.com/vi/{video_id}/{quality}.jpg"


def validate_youtube_url(url: str) -> bool:
    """
    Check if URL is a valid, supported YouTube format.
    
    Args:
        url: User-pasted URL
        
    Returns:
        True if valid YouTube URL, False otherwise
    """
    return extract_video_id(url) is not None


def parse_youtube_url(url: str) -> YouTubeData:
    """
    Parse YouTube URL and return normalized data for storage.
    
    This is the main function to use when processing user input.
    
    Args:
        url: YouTube URL pasted by user
        
    Returns:
        YouTubeData object with normalized fields
        
    Raises:
        YouTubeURLError: If URL is invalid or unsupported
        
    Example:
        >>> data = parse_youtube_url('https://youtu.be/dQw4w9WgXcQ')
        >>> data.video_id
        'dQw4w9WgXcQ'
        >>> data.embed_url
        'https://www.youtube.com/embed/dQw4w9WgXcQ'
    """
    if not url or not isinstance(url, str):
        raise YouTubeURLError("URL is required and must be a string")
    
    # Clean input
    url = url.strip()
    
    # Extract video ID
    video_id = extract_video_id(url)
    if not video_id:
        raise YouTubeURLError(
            "Invalid YouTube URL. Please paste a valid YouTube link."
        )
    
    # Generate normalized URLs
    return YouTubeData(
        video_id=video_id,
        embed_url=generate_embed_url(video_id),
        thumbnail_url=generate_thumbnail_url(video_id),
        original_url=url
    )
