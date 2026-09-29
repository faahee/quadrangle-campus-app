import 'package:flutter/material.dart';

/// Colour system for Quadrangle.
/// A classic university palette: Oxford navy (primary), heritage gold
/// (accent), and two warm background tints (ivory and parchment).
class AppColors {
  AppColors._();

  // Primary + accent
  static const Color navy = Color(0xFF14213D);
  static const Color navyLight = Color(0xFF24365E);
  static const Color gold = Color(0xFFC9A227);
  static const Color goldDeep = Color(0xFF8A6A0E);

  // Supporting background tints
  static const Color ivory = Color(0xFFFBF8F1);
  static const Color parchment = Color(0xFFF3ECDC);
  static const Color mist = Color(0xFFE9EEF6);

  // Neutrals
  static const Color surface = Colors.white;
  static const Color ink = Color(0xFF1C2433);
  static const Color muted = Color(0xFF5B6475);
  static const Color line = Color(0xFFE4DCCB);

  // Status colours
  static const Color success = Color(0xFF2E6B45);
  static const Color successTint = Color(0xFFE3F1E7);
  static const Color warning = Color(0xFF9A5B0B);
  static const Color warningTint = Color(0xFFFDF1DC);
  static const Color danger = Color(0xFF8E2231);
  static const Color dangerTint = Color(0xFFF8E3E5);
  static const Color info = Color(0xFF24507F);
  static const Color infoTint = Color(0xFFE3ECF7);
}

/// Shared card style so every card in the app looks consistent:
/// radius 16, 1px parchment border, soft navy shadow, 16px spacing.
class AppStyle {
  AppStyle._();

  static const double radius = 16;
  static const double gap = 16;

  static BorderRadius get cardRadius => BorderRadius.circular(radius);

  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: AppColors.navy.withValues(alpha: 0.07),
      blurRadius: 14,
      offset: const Offset(0, 5),
    ),
  ];

  static BoxDecoration card({Color color = AppColors.surface}) => BoxDecoration(
    color: color,
    borderRadius: cardRadius,
    border: Border.all(color: AppColors.line),
    boxShadow: softShadow,
  );

  // Classic serif headings (Georgia on iOS, Noto Serif on Android).
  static const List<String> serifFallback = [
    'Georgia',
    'Times New Roman',
    'Noto Serif',
    'serif',
  ];

  static const TextStyle heading = TextStyle(
    fontFamily: 'Georgia',
    fontFamilyFallback: serifFallback,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.navy,
  );
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.navy,
      primary: AppColors.navy,
      secondary: AppColors.gold,
      surface: AppColors.surface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.ivory,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: 'Georgia',
          fontFamilyFallback: AppStyle.serifFallback,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: AppColors.parchment,
        height: 68,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? AppColors.navy
                : AppColors.muted,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? AppColors.navy
                : AppColors.muted,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.navy,
        contentTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
        actionTextColor: AppColors.gold,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.navy,
          foregroundColor: Colors.white,
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.navy,
          minimumSize: const Size(48, 48),
          side: const BorderSide(color: AppColors.navy),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.navy,
          minimumSize: const Size(48, 48),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        selectedColor: AppColors.navy,
        side: const BorderSide(color: AppColors.line),
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        secondaryLabelStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.navy, width: 1.5),
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.line, space: 1),
    );
  }
}
