"""
Share code generation for Digital Cassette.
Generates unique 6-character uppercase alphanumeric codes.
"""
import secrets
from sqlalchemy.orm import Session


# Characters for share code (avoid confusing chars: 0, O, I, 1)
SHARE_CODE_CHARS = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'
SHARE_CODE_LENGTH = 6


def generate_share_code() -> str:
    """
    Generate a 6-character uppercase alphanumeric share code.
    
    Excludes confusing characters: 0, O, I, 1
    
    Returns:
        6-character code like "AX34DF"
        
    Example:
        >>> code = generate_share_code()
        >>> len(code)
        6
        >>> code.isupper()
        True
    """
    return ''.join(secrets.choice(SHARE_CODE_CHARS) for _ in range(SHARE_CODE_LENGTH))


def generate_unique_share_code(db: Session, model_class, max_attempts: int = 10) -> str:
    """
    Generate a unique share code that doesn't exist in the database.
    
    Args:
        db: SQLAlchemy database session
        model_class: Model to check against (e.g., Cassette)
        max_attempts: Maximum retry attempts if collision occurs
        
    Returns:
        Unique 6-character share code
        
    Raises:
        RuntimeError: If unable to generate unique code after max_attempts
        
    Example:
        >>> from app.models.cassette import Cassette
        >>> code = generate_unique_share_code(db, Cassette)
        >>> existing = db.query(Cassette).filter_by(shareCode=code).first()
        >>> existing is None
        True
    """
    for _ in range(max_attempts):
        code = generate_share_code()
        
        # Check if code already exists
        existing = db.query(model_class).filter_by(shareCode=code).first()
        if not existing:
            return code
    
    raise RuntimeError(
        f"Failed to generate unique share code after {max_attempts} attempts"
    )


def validate_share_code(code: str) -> bool:
    """
    Validate share code format.
    
    Args:
        code: Share code to validate
        
    Returns:
        True if valid format, False otherwise
    """
    if not code or not isinstance(code, str):
        return False
    
    if len(code) != SHARE_CODE_LENGTH:
        return False
    
    if not code.isupper():
        return False
    
    return all(c in SHARE_CODE_CHARS for c in code)
