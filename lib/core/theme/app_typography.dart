import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography system for Digital Cassette
/// - Playfair Display: Headings (elegant serif)
/// - Caveat: Letters/Handwritten text (nostalgic cursive)
/// - Inter: UI/Body text (clean and readable)
class AppTypography {
  AppTypography._();

  // Heading Styles (Playfair Display - Serif)
  static TextStyle h1 = GoogleFonts.playfairDisplay(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: AppColors.primaryText,
  );

  static TextStyle h2 = GoogleFonts.playfairDisplay(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.3,
    color: AppColors.primaryText,
  );

  static TextStyle h3 = GoogleFonts.playfairDisplay(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.primaryText,
  );

  // Body Styles (Inter - UI Font)
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.primaryText,
  );

  static TextStyle body = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: AppColors.primaryText,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.primaryText,
  );

  static TextStyle caption = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.mutedText,
  );

  // Handwritten Style (Caveat - Letters)
  static TextStyle handwritten = GoogleFonts.caveat(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: AppColors.primaryText,
  );

  static TextStyle handwrittenLarge = GoogleFonts.caveat(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.5,
    color: AppColors.primaryText,
  );

  // Button Styles
  static TextStyle button = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.0,
    letterSpacing: 0.5,
  );

  // Utility methods
  static TextStyle bodySmallSecondary = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.mutedText,
  );

  static TextStyle captionLight = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.mutedText,
  );
}
