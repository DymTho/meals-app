import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/dummy_data.dart';
import '../models/meal.dart';

/// Keeps track of which meals the user marked as favorite.
///
/// Only the meal ids are stored (as a list of strings in SharedPreferences);
/// the actual [Meal] objects always come from [dummyMeals], so favorites
/// stay in sync if the data ever changes.
class FavoritesProvider extends ChangeNotifier {
  static const _storageKey = 'favorite_meal_ids';

  final Set<String> _favoriteIds = {};

  List<Meal> get favoriteMeals =>
      dummyMeals.where((meal) => _favoriteIds.contains(meal.id)).toList();

  bool isFavorite(String mealId) => _favoriteIds.contains(mealId);

  /// Reads saved favorite ids. Call once when the app starts.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIds = prefs.getStringList(_storageKey) ?? [];
    _favoriteIds
      ..clear()
      ..addAll(savedIds);
    notifyListeners();
  }

  /// Adds or removes a meal from favorites and returns whether it is now
  /// favorite, so the caller can show a matching snackbar message.
  Future<bool> toggleFavorite(Meal meal) async {
    final isNowFavorite = !_favoriteIds.contains(meal.id);
    if (isNowFavorite) {
      _favoriteIds.add(meal.id);
    } else {
      _favoriteIds.remove(meal.id);
    }
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, _favoriteIds.toList());
    return isNowFavorite;
  }
}
