import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// One selectable color scheme for the app. The user picks one of these in
/// the theme switcher; [buildAppTheme] turns it into a full [ThemeData].
enum AppThemeId { tomato, basil, berry }

class AppThemePreset {
  const AppThemePreset({
    required this.id,
    required this.label,
    required this.seedColor,
  });

  final AppThemeId id;
  final String label;
  final Color seedColor;
}

const appThemePresets = [
  AppThemePreset(id: AppThemeId.tomato, label: 'Tomato', seedColor: Color(0xFFE1512D)),
  AppThemePreset(id: AppThemeId.basil, label: 'Basil', seedColor: Color(0xFF3F7D3A)),
  AppThemePreset(id: AppThemeId.berry, label: 'Berry', seedColor: Color(0xFF9C2A6E)),
];

AppThemePreset presetById(AppThemeId id) =>
    appThemePresets.firstWhere((preset) => preset.id == id);

/// Builds the whole Material 3 theme from one seed color, so every screen
/// (buttons, cards, switches, app bar) stays visually consistent no matter
/// which preset is selected. [brightness] follows the system light/dark
/// setting.
ThemeData buildAppTheme(Color seedColor, Brightness brightness) {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: brightness,
  );
  final base = ThemeData(colorScheme: colorScheme, useMaterial3: true);

  // Two Google Fonts paired together: an elegant serif for titles (recipe
  // names, section headers) and a clean sans-serif for everything else.
  final bodyTextTheme = GoogleFonts.nunitoTextTheme(base.textTheme);
  final displayFont = GoogleFonts.playfairDisplay();
  final textTheme = bodyTextTheme.copyWith(
    headlineSmall: displayFont.copyWith(
      fontWeight: FontWeight.w700,
      color: bodyTextTheme.headlineSmall?.color,
    ),
    titleLarge: displayFont.copyWith(
      fontWeight: FontWeight.w600,
      color: bodyTextTheme.titleLarge?.color,
    ),
    titleMedium: displayFont.copyWith(
      fontWeight: FontWeight.w600,
      color: bodyTextTheme.titleMedium?.color,
    ),
  );

  return base.copyWith(
    textTheme: textTheme,
    scaffoldBackgroundColor: colorScheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      elevation: 2,
      centerTitle: false,
      titleTextStyle: displayFont.copyWith(
        color: colorScheme.onPrimary,
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 4,
      shadowColor: colorScheme.primary.withValues(alpha: 0.3),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: colorScheme.surfaceContainerHighest,
      labelStyle: textTheme.labelMedium,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 3,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? colorScheme.primary
            : null,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: colorScheme.surface,
      indicatorColor: colorScheme.primaryContainer,
      elevation: 3,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}
