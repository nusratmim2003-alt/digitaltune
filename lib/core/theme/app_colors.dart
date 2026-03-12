import 'package:flutter/material.dart';

/// Digital Cassette — Color Theme System
/// Warm nostalgic cassette aesthetic with paper textures and vintage tones
class AppColors {
  AppColors._();

  // Primary Background & Surfaces
  static const Color background = Color(0xFFF5F0E8); // Main app background
  static const Color paper =
      Color(0xFFEBE3D5); // Cards, sections, cassette areas

  // Text Colors
  static const Color primaryText = Color(0xFF2E1E0F); // Main readable text
  static const Color mutedText = Color(0xFF6E5C4F); // Descriptions and labels

  // Accent & Brand Colors
  static const Color accent = Color(0xFFD6A441); // Buttons and highlights

  // Cassette Colors
  static const Color cassetteBrown = Color(0xFF3B2314); // Cassette body
  static const Color reelBrown = Color(0xFF5A3A28); // Tape reel ring
  static const Color vinylBlack = Color(0xFF1C1C1C); // Tape window

  // UI Elements
  static const Color border = Color(0xFFD8CBB7); // Subtle vintage borders

  // Semantic Colors
  static const Color error = Color(0xFFC6453C); // Password errors etc.
  static const Color success = Color(0xFF4C8B4A); // Success states

  // Accent Gradient (Golden Buttons)
  static const LinearGradient accentGradient = LinearGradient(
    colors: [
      Color(0xFFC89334),
      Color(0xFFE7BE6A),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Legacy support (keep for backward compatibility during migration)
  static const Color paperTone = background;
  static const Color deepBrown = primaryText;
  static const Color amberAccent = accent;
  static const Color lightBrown = mutedText;
  static const Color cream = paper;
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color greyLight = Color(0xFFEFEBE9);
  static const Color greyMedium = Color(0xFFD7CCC8);
  static const Color softShadow = Color(0x1A3E2723);

  // Emotion Tag Colors
  static const Color love = Color(0xFFE91E63); // Pink
  static const Color nostalgia = Color(0xFF795548); // Brown
  static const Color friendship = Color(0xFF4CAF50); // Green
  static const Color missingYou = Color(0xFF9C27B0); // Purple
  static const Color apology = Color(0xFF2196F3); // Blue
  static const Color warning = Color(0xFFFFA726); // Orange
  static const Color info = Color(0xFF42A5F5); // Blue

  /// Get emotion color by tag name
  static Color getEmotionColor(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'love':
        return love;
      case 'nostalgia':
        return nostalgia;
      case 'friendship':
        return friendship;
      case 'missing you':
      case 'missingyou':
        return missingYou;
      case 'apology':
        return apology;
      default:
        return primaryText;
    }
  }
}
