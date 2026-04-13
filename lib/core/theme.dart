import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KalimaColors {
  static const background = Color(0xFF06060F);
  static const backgroundLight = Color(0xFF0E0E1F);
  static const surface = Color(0xFF151530);
  static const surfaceLight = Color(0xFF1E1E45);
  static const correct = Color(0xFF2DD4A8);
  static const present = Color(0xFFFBBF24);
  static const absent = Color(0xFF3A3A5C);
  static const accent = Color(0xFFCCFF00);
  static const accentDim = Color(0xFF99CC00);
  static const cardTeal = Color(0xFF06B6D4);
  static const cardCoral = Color(0xFFF97316);
  static const cardPurple = Color(0xFF8B5CF6);
  static const cardPink = Color(0xFFEC4899);
  static const cardBlue = Color(0xFF3B82F6);
  static const white = Colors.white;
  static const error = Color(0xFFEF4444);

  static const rawabetYellow = Color(0xFFFBBF24);
  static const rawabetGreen = Color(0xFF2DD4A8);
  static const rawabetPink = Color(0xFFBE185D);
  static const rawabetPurple = Color(0xFF8B5CF6);

  static const rawabetColors = [rawabetYellow, rawabetGreen, rawabetPink, rawabetPurple];

  static const nahlaGold = Color(0xFFFFD700);
  static const nahlaAmber = Color(0xFFF59E0B);
}

class KalimaTheme {
  // Typography
  static TextStyle get cairoW900 => GoogleFonts.cairo(fontWeight: FontWeight.w900);
  static TextStyle get cairoW800 => GoogleFonts.cairo(fontWeight: FontWeight.w800);
  static TextStyle get cairoW700 => GoogleFonts.cairo(fontWeight: FontWeight.w700);
  static TextStyle get cairoW600 => GoogleFonts.cairo(fontWeight: FontWeight.w600);
  static TextStyle get cairoW500 => GoogleFonts.cairo(fontWeight: FontWeight.w500);
  static TextStyle get cairoW400 => GoogleFonts.cairo(fontWeight: FontWeight.w400);

  // Background gradient - deep space feel
  static BoxDecoration get backgroundGradient => const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: 1.5,
          colors: [
            Color(0xFF12122A),
            Color(0xFF0A0A18),
            KalimaColors.background,
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      );

  // 3D card with float effect
  static BoxDecoration card3D({Color? color, double elevation = 8}) {
    final c = color ?? KalimaColors.surface;
    return BoxDecoration(
      color: c,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        // Top highlight
        BoxShadow(
          color: Colors.white.withValues(alpha: 0.06),
          blurRadius: 1,
          offset: const Offset(0, -1),
        ),
        // Main shadow
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.5),
          blurRadius: elevation,
          offset: Offset(0, elevation / 2),
        ),
        // Ambient glow if colored
        if (color != null)
          BoxShadow(
            color: c.withValues(alpha: 0.2),
            blurRadius: elevation * 2,
            spreadRadius: 1,
          ),
      ],
    );
  }

  // Glassmorphism container
  static BoxDecoration get glass => BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      );

  // 3D tile for game grids
  static BoxDecoration tile3D({Color? color}) {
    final c = color ?? KalimaColors.surface;
    return BoxDecoration(
      color: c,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.white.withValues(alpha: 0.08),
          blurRadius: 1,
          offset: const Offset(0, -1),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.5),
          blurRadius: 6,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // Revealed tile with glow
  static BoxDecoration tileRevealed(Color color) => BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 16,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      );

  // Empty tile
  static BoxDecoration get tileEmpty => BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF2A2A4A),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      );

  // 3D keyboard key
  static BoxDecoration key3D({Color? color}) {
    final c = color ?? KalimaColors.surface;
    return BoxDecoration(
      color: c,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.white.withValues(alpha: 0.06),
          blurRadius: 1,
          offset: const Offset(0, -1),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.4),
          blurRadius: 4,
          offset: const Offset(0, 3),
        ),
        if (color != null && color != KalimaColors.surface && color != KalimaColors.absent)
          BoxShadow(
            color: c.withValues(alpha: 0.25),
            blurRadius: 8,
          ),
      ],
    );
  }

  // Neon button
  static BoxDecoration neonButton({Color? color, bool enabled = true}) {
    final c = color ?? KalimaColors.accent;
    return BoxDecoration(
      color: enabled ? c : c.withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(14),
      boxShadow: enabled
          ? [
              BoxShadow(
                color: c.withValues(alpha: 0.4),
                blurRadius: 16,
                spreadRadius: 1,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 4,
                offset: const Offset(0, 3),
              ),
            ]
          : [],
    );
  }

  // Game card gradient for home screen
  static BoxDecoration gameCard({
    required Color color1,
    required Color color2,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [color1, color2],
      ),
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: color1.withValues(alpha: 0.3),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.3),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // Top highlight overlay for 3D cards
  static BoxDecoration get topHighlight => BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: 0.15),
            Colors.white.withValues(alpha: 0.0),
          ],
          stops: const [0.0, 0.4],
        ),
      );

  // Hexagon decoration for nahla
  static BoxDecoration hexButton({Color? color, bool isCenter = false}) {
    final c = color ?? KalimaColors.surface;
    return BoxDecoration(
      color: c,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.4),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
        if (isCenter)
          BoxShadow(
            color: KalimaColors.nahlaGold.withValues(alpha: 0.3),
            blurRadius: 12,
            spreadRadius: 2,
          ),
      ],
    );
  }
}

// Reusable glass container widget
class GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double borderRadius;

  const GlassContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: padding ?? const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
