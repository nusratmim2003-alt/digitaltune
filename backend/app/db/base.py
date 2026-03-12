"""
Import all models here so Alembic can discover them.
"""

from app.db.base_class import Base

from app.models.user import User
from app.models.cassette import Cassette
from app.models.saved_cassette import SavedCassette
from app.models.cassette_reply import CassetteReply