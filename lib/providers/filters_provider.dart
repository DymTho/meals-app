import 'package:flutter/material.dart';

import '../models/meal.dart';

/// The four dietary filters required by the assignment.
enum Filter { glutenFree, lactoseFree, vegetarian, vegan }

/// Holds which dietary filters are currently switched on and filters the
/// meal list accordingly. Filters are not persisted on purpose: they reset
/// to "show everything" the next time the app is opened.
class FiltersProvider extends ChangeNotifier {
  final Map<Filter, bool> _selectedFilters = {
    Filter.glutenFree: false,
    Filter.lactoseFree: false,
    Filter.vegetarian: false,
    Filter.vegan: false,
  };

  Map<Filter, bool> get selectedFilters => _selectedFilters;

  void setFilter(Filter filter, bool isActive) {
    _selectedFilters[filter] = isActive;
    notifyListeners();
  }

  /// True if the user turned at least one filter on.
  bool get hasActiveFilters => _selectedFilters.values.any((value) => value);

  /// Removes meals that don't match the currently active filters.
  List<Meal> applyTo(List<Meal> meals) {
    return meals.where((meal) {
      if (_selectedFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if (_selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (_selectedFilters[Filter.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      if (_selectedFilters[Filter.vegan]! && !meal.isVegan) {
        return false;
      }
      return true;
    }).toList();
  }
}
