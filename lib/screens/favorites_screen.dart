import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favorites_provider.dart';
import '../providers/filters_provider.dart';
import '../widgets/meals_list.dart';

/// The user's saved favorite meals (assignment req. 5), also respecting the
/// active dietary filters so the whole app stays consistent.
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteMeals = context.watch<FavoritesProvider>().favoriteMeals;
    final visibleMeals = context.watch<FiltersProvider>().applyTo(favoriteMeals);

    return MealsList(
      meals: visibleMeals,
      emptyMessage: favoriteMeals.isEmpty
          ? 'You have no favorite meals yet.\nTap the star on a meal to save it here.'
          : 'No favorites match the current filters.',
    );
  }
}
