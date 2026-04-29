import 'package:flutter/material.dart';

extension ThemeExt on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Color get bg => Theme.of(this).scaffoldBackgroundColor;
  Color get bgSidebar => isDark ? AppColors.darkBgSidebar : AppColors.lightBgSidebar;
  Color get bgPanel => Theme.of(this).colorScheme.surface;
  Color get bgInput => isDark ? AppColors.darkBgInput : AppColors.lightBgInput;
  Color get bgMsgAi => isDark ? AppColors.darkBgMsgAi : AppColors.lightBgMsgAi;
  Color get bgHover => isDark ? AppColors.darkBgHover : AppColors.lightBgHover;
  Color get border => Theme.of(this).dividerColor;
  Color get borderFaint => isDark ? AppColors.darkBorderFaint : AppColors.lightBorderFaint;
  
  Color get text => isDark ? AppColors.darkText : AppColors.lightText;
  Color get textM => isDark ? AppColors.darkTextM : AppColors.lightTextM;
  Color get textD => isDark ? AppColors.darkTextD : AppColors.lightTextD;
}

/// Aurora AI design tokens — futuristic dark theme with neon accents.
class AppColors {
  AppColors._();

  // ── Primary Accent Colors ──────────────────────────────────────
  static const accent    = Color(0xFF7C5CFF); // Purple primary
  static const accentDim = Color(0xFF6244E0); // Darker purple
  static const accentHi  = Color(0xFF9B7FFF); // Lighter purple

  // ── Neon Accent Colors ─────────────────────────────────────────
  static const neonCyan  = Color(0xFF00E5FF); // Neon cyan highlight
  static const pinkAccent = Color(0xFFFF4D9D); // Pink accent

  // ── Status Colors ──────────────────────────────────────────────
  static const green  = Color(0xFF34D399); // Emerald / success
  static const red    = Color(0xFFF43F5E); // Rose / error
  static const orange = Color(0xFFFBBF24); // Amber / warning

  // ── Dark Theme Colors (AI-themed deep dark) ────────────────────
  static const darkBg          = Color(0xFF0B0F1A); // Deep space background
  static const darkBgSidebar   = Color(0xFF0D1120); // Sidebar, slightly lighter
  static const darkBgPanel     = Color(0xFF121826); // Glass card / panel
  static const darkBgInput     = Color(0xFF141C2E); // Input fields
  static const darkBgMsgAi     = Color(0xFF0F1525); // AI message row
  static const darkBgHover     = Color(0xFF1A2340); // Hover state
  static const darkBorder      = Color(0xFF1E293B); // Card borders
  static const darkBorderFaint = Color(0xFF151D30); // Subtle separators
  static const darkText        = Color(0xFFFFFFFF); // Pure white primary text
  static const darkTextM       = Color(0xFF9CA3AF); // Soft gray secondary
  static const darkTextD       = Color(0xFF4B5563); // Dim / timestamps

  // ── Light Theme Colors ─────────────────────────────────────────
  static const lightBg          = Color(0xFFF8FAFC);
  static const lightBgSidebar   = Color(0xFFF1F5F9);
  static const lightBgPanel     = Color(0xFFFFFFFF);
  static const lightBgInput     = Color(0xFFF8FAFC);
  static const lightBgMsgAi     = Color(0xFFF1F5F9);
  static const lightBgHover     = Color(0xFFE2E8F0);
  static const lightBorder      = Color(0xFFE2E8F0);
  static const lightBorderFaint = Color(0xFFF1F5F9);
  static const lightText        = Color(0xFF0F172A);
  static const lightTextM       = Color(0xFF475569);
  static const lightTextD       = Color(0xFF94A3B8);

  // ── Label colours ────────────────────────────────────────────
  static const uncensored = Color(0xFFF43F5E);
  static const standard   = Color(0xFF00E5FF);
  static const custom     = Color(0xFF34D399);

  // ── Gradients ────────────────────────────────────────────────
  static const accentGradient = LinearGradient(
    colors: [accent, neonCyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const buttonGradient = LinearGradient(
    colors: [accent, Color(0xFF5B8DEF), neonCyan],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const glowGradient = LinearGradient(
    colors: [accent, pinkAccent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Glass / Frosted Helpers ──────────────────────────────────
  static const glassWhite    = Color(0x0DFFFFFF); // 5% white overlay
  static const glassBorder   = Color(0x1AFFFFFF); // 10% white border
  static const glassHighlight = Color(0x0D7C5CFF); // 5% accent overlay
}
