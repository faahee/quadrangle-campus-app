import 'package:flutter/material.dart';

/// Colour system for Quadrangle, built from the MP072 palette:
///
///  * Blue Fantastic `#2C3B4D` – primary
///  * Abyssal Anchorfish Blue `#1B2632` – deep primary / ink
///  * Burning Flame `#FFB162` – accent
///  * Truffle Trouble `#A35139` – secondary accent
///  * Palladian `#EEE9DF` and Oatmeal `#C9C1B1` – background tints
class AppColors {
  AppColors._();

  // Palette
  static const Color blueFantastic = Color(0xFF2C3B4D);
  static const Color abyss = Color(0xFF1B2632);
  static const Color flame = Color(0xFFFFB162);
  static const Color truffle = Color(0xFFA35139);
  static const Color palladian = Color(0xFFEEE9DF);
  static const Color oatmeal = Color(0xFFC9C1B1);

  // Roles (names kept short so widgets read clearly)
  static const Color navy = blueFantastic;
  static const Color navyLight = Color(0xFF3B4D63);
  static const Color gold = flame;
  static const Color goldDeep = truffle; // accent text on light backgrounds

  // Supporting background tints
  static const Color ivory = palladian;
  static const Color parchment = Color(0xFFE5DED1);
  static const Color mist = Color(0xFFE2E6EA);

  // Neutrals
  static const Color surface = Color(0xFFFBF9F5);
  static const Color ink = abyss;
  static const Color muted = Color(0xFF5E6670);
  static const Color line = Color(0xFFD9D2C4);

  // Status colours (harmonised with the palette)
  static const Color success = Color(0xFF4F7A5C);
  static const Color successTint = Color(0xFFE3ECE5);
  static const Color warning = Color(0xFF9E5A17);
  static const Color warningTint = Color(0xFFFFEBD3);
  static const Color danger = truffle;
  static const Color dangerTint = Color(0xFFF4E2DB);
  static const Color info = blueFantastic;
  static const Color infoTint = Color(0xFFE2E6EB);
}

/// Shared card style so every card in the app looks consistent:
/// radius 16, 1px oatmeal border, soft blue shadow, 16px spacing.
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
