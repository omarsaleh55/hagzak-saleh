import 'package:flutter/material.dart';

abstract final class AuthColors {
  // ── Brand ───────────────────────────────────────────────────────────────────
  static const Color darkEmerald = Color(0xFF012D1D);
  static const Color emeraldDeep = Color(0xFF1B4332);
  static const Color teal = Color(0xFF2C694E);
  static const Color lime = Color(0xFFCAF300);
  static const Color limeDim = Color(0xFFB0D500);
  static const Color onLime = Color(0xFF171E00);

  // ── Header gradient ─────────────────────────────────────────────────────────
  static const Color emerald950 = Color(0xFF022C22); // Tailwind emerald-950
  static const Color emerald900 = Color(0xFF064E3B); // Tailwind emerald-900
  static const Color lime400 = Color(0xFFA3E635); // Tailwind lime-400

  // ── Surfaces ────────────────────────────────────────────────────────────────
  static const Color surface = Color(0xFFF8F9FA);
  static const Color surfaceContainerLow = Color(0xFFF3F4F5);
  static const Color surfaceContainerHigh = Color(0xFFE7E8E9);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerHighest = Color(0xFFE1E3E4);

  // ── Content ─────────────────────────────────────────────────────────────────
  static const Color onSurface = Color(0xFF191C1D);
  static const Color onSurfaceVariant = Color(0xFF414844);
  static const Color outlineVariant = Color(0xFFC1C8C2);
  static const Color outline = Color(0xFF717973);

  // ── Pre-baked alpha variants (avoids withOpacity) ───────────────────────────
  static const Color headerBg = Color(0xB3012D1D); // darkEmerald @ 70 %
  static const Color limeGlow = Color(0x33CAF300); // lime @ 20 %
  static const Color limeBorder = Color(0xCCCAF300); // lime @ 80 %
  static const Color dividerLine = Color(0x4DC1C8C2); // outlineVariant @ 30 %
  static const Color borderFaint = Color(0x33C1C8C2); // outlineVariant @ 20 %
  static const Color hintText = Color(0x66717973); // outline @ 40 %
}
