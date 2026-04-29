import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBg,
      primaryColor: AppColors.accent,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accent,
        secondary: AppColors.neonCyan,
        tertiary: AppColors.pinkAccent,
        surface: AppColors.darkBgPanel,
        error: AppColors.red,
      ),
      textTheme: ThemeData.dark().textTheme.apply(
        bodyColor: AppColors.darkText,
        displayColor: AppColors.darkText,
        ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBgPanel,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.darkText,
            ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintStyle: const TextStyle(color: AppColors.darkTextD, fontSize: 14),
        filled: true,
        fillColor: AppColors.darkBgInput,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
                ),
          elevation: 0,
        ),
      ),
      dividerColor: AppColors.darkBorder,
      cardColor: AppColors.darkBgPanel,
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkBgPanel,
        contentTextStyle: const TextStyle(color: AppColors.darkText, fontFamily: 'Inter'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.darkBgPanel,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: const TextStyle(
          color: AppColors.darkText,
          fontSize: 18,
          fontWeight: FontWeight.w600,
            ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.darkBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.accent;
          return AppColors.darkTextD;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.accent.withValues(alpha: 0.3);
          }
          return AppColors.darkBorder;
        }),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.accent,
        inactiveTrackColor: AppColors.darkBorder,
        thumbColor: AppColors.accent,
        overlayColor: AppColors.accent.withValues(alpha: 0.15),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBg,
      primaryColor: AppColors.accent,
      colorScheme: const ColorScheme.light(
        primary: AppColors.accent,
        secondary: AppColors.neonCyan,
        tertiary: AppColors.pinkAccent,
        surface: AppColors.lightBgPanel,
        error: AppColors.red,
      ),
      textTheme: ThemeData.light().textTheme.apply(
        bodyColor: AppColors.lightText,
        displayColor: AppColors.lightText,
        ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightBgPanel,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.lightText),
        titleTextStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.lightText,
            ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintStyle: const TextStyle(color: AppColors.lightTextD, fontSize: 14),
        filled: true,
        fillColor: AppColors.lightBgInput,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
                ),
          elevation: 0,
        ),
      ),
      dividerColor: AppColors.lightBorder,
      cardColor: AppColors.lightBgPanel,
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.lightBgPanel,
        contentTextStyle: const TextStyle(color: AppColors.lightText, fontFamily: 'Inter'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.lightBgPanel,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: const TextStyle(
          color: AppColors.lightText,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.lightBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.accent;
          return AppColors.lightTextD;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.accent.withValues(alpha: 0.3);
          }
          return AppColors.lightBorder;
        }),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.accent,
        inactiveTrackColor: AppColors.lightBorder,
        thumbColor: AppColors.accent,
        overlayColor: AppColors.accent.withValues(alpha: 0.15),
      ),
    );
  }
}
