"""
Enums for Digital Cassette backend.
"""
from enum import Enum


class EmotionTag(str, Enum):
    """Fixed emotion tags for cassettes."""
    JOYFUL = "Joyful"
    MELANCHOLIC = "Melancholic"
    NOSTALGIC = "Nostalgic"
    HOPEFUL = "Hopeful"
    ROMANTIC = "Romantic"
    BITTERSWEET = "Bittersweet"
    PEACEFUL = "Peaceful"
    ENERGETIC = "Energetic"
