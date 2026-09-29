import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/dummy_data.dart';
import '../models/category.dart';
import '../providers/filters_provider.dart';
import '../widgets/meals_list.dart';

/// All meals belonging to one selected category (assignment req. 2), with
/// the active dietary filters already applied.
class MealsScreen extends StatelessWidget {
  const MealsScreen({super.key, required this.category});

  final Category category;

  @override
  Widget build(BuildContext context) {
    final filters = context.watch<FiltersProvider>();
    final categoryMeals =
        dummyMeals.where((meal) => meal.categories.contains(category.id)).toList();
    final visibleMeals = filters.applyTo(categoryMeals);

    return Scaffold(
      appBar: AppBar(title: Text(category.title)),
      body: MealsList(
        meals: visibleMeals,
        emptyMessage: 'No meals found for the current filters.',
      ),
    );
  }
}
