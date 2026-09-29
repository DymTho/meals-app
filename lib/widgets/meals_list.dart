import 'package:flutter/material.dart';

import '../models/meal.dart';
import 'meal_item.dart';

/// Renders a list of meals, or a friendly message if [meals] is empty
/// (used both when a category has no meals left after filtering, and for
/// the empty favorites screen).
class MealsList extends StatelessWidget {
  const MealsList({super.key, required this.meals, required this.emptyMessage});

  final List<Meal> meals;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (meals.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            emptyMessage,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: meals.length,
      itemBuilder: (context, index) => MealItem(meal: meals[index]),
    );
  }
}
