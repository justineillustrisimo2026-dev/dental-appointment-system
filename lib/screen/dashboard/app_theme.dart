// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class AppTheme {
  // ── EXACT PALETTE ──
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color inputCream = Color(0xFFFAF6EE);
  static const Color goldDeep = Color(0xFFB88A44);
  static const Color goldMid = Color(0xFFD4AF37);
  static const Color goldShine = Color(0xFFF0D86C);
  static const Color goldPrimary = Color(0xFFB59410);
  static const Color textDark = Color(0xFF2C2410);
  static const Color textMuted = Color(0xFF8A7A5A);

  static LinearGradient get goldGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [goldDeep, goldMid, goldShine, goldMid],
    stops: [0.0, 0.35, 0.65, 1.0],
  );

  // ── DYNAMIC THEME COLORS ──
  static Color bg(bool isDark) =>
      isDark ? const Color(0xFF1A160F) : const Color(0xFFF9F9F9);
  static Color cardBg(bool isDark) =>
      isDark ? const Color(0xFF262016) : cardWhite;
  static Color surface(bool isDark) =>
      isDark ? const Color(0xFF1A160F) : Colors.white;
  static Color innerSurface(bool isDark) =>
      isDark ? const Color(0xFF332B1E) : inputCream;
  static Color txt(bool isDark) => isDark ? inputCream : textDark;
  static Color txtMuted(bool isDark) =>
      isDark ? const Color(0xFFA6967A) : textMuted;
  static Color bdr(bool isDark) =>
      isDark ? const Color(0xFF403626) : goldMid.withOpacity(0.20);

  // ── INPUT TEXT COLOR (Forces stark black text on light mode) ──
  static Color inputTxt(bool isDark) => isDark ? Colors.white : Colors.black;

  static List<BoxShadow> profileShadow(bool isDark) => [
    BoxShadow(
      color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
      blurRadius: 15,
      offset: const Offset(0, 5),
    ),
  ];
}

// ── PERFECTED GOLD PAINTER ──
class PerfectGoldPainter extends CustomPainter {
  final LinearGradient gradient;
  PerfectGoldPainter(this.gradient);

  @override
  void paint(Canvas canvas, Size size) {
    final Rect fullRect = Offset.zero & size;
    final Paint frontPaint = Paint()
      ..shader = gradient.createShader(fullRect)
      ..style = PaintingStyle.fill;
    final Paint backPaint = Paint()
      ..shader = gradient.createShader(fullRect)
      ..style = PaintingStyle.fill
      ..colorFilter = ColorFilter.mode(
        Colors.white.withOpacity(0.6),
        BlendMode.modulate,
      );

    // Top Right Layered Curves
    final Path topBack = Path()
      ..moveTo(size.width * 0.35, 0)
      ..cubicTo(
        size.width * 0.5,
        size.height * 0.22,
        size.width * 0.85,
        size.height * 0.05,
        size.width,
        size.height * 0.2,
      )
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(topBack, backPaint);

    final Path topFront = Path()
      ..moveTo(size.width * 0.5, 0)
      ..cubicTo(
        size.width * 0.65,
        size.height * 0.15,
        size.width * 0.9,
        0,
        size.width,
        size.height * 0.1,
      )
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(topFront, frontPaint);

    // Bottom Left Layered Curves
    final Path bottomBack = Path()
      ..moveTo(size.width * 0.65, size.height)
      ..cubicTo(
        size.width * 0.5,
        size.height * 0.78,
        size.width * 0.15,
        size.height * 0.95,
        0,
        size.height * 0.8,
      )
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(bottomBack, backPaint);

    final Path bottomFront = Path()
      ..moveTo(size.width * 0.5, size.height)
      ..cubicTo(
        size.width * 0.35,
        size.height * 0.85,
        size.width * 0.1,
        size.height,
        0,
        size.height * 0.9,
      )
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(bottomFront, frontPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
