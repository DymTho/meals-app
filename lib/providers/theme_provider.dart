import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/app_theme.dart';

/// Holds the selected color theme. It is a [ChangeNotifier]: any widget
/// wrapped in a `Consumer<ThemeProvider>` (or using `context.watch`)
/// rebuilds automatically when [selectTheme] is called.
///
/// The choice is saved with SharedPreferences so it survives app restarts.
class ThemeProvider extends ChangeNotifier {
  static const _storageKey = 'selected_theme';

  AppThemeId _themeId = AppThemeId.tomato;
  AppThemeId get themeId => _themeId;
  AppThemePreset get preset => presetById(_themeId);

  /// Reads the saved theme, if any. Call once when the app starts.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString(_storageKey);
    if (savedName == null) return;
    _themeId = AppThemeId.values.firstWhere(
      (id) => id.name == savedName,
      orElse: () => AppThemeId.tomato,
    );
    notifyListeners();
  }

  Future<void> selectTheme(AppThemeId id) async {
    if (id == _themeId) return;
    _themeId = id;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, id.name);
  }
}
