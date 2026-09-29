import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import 'meals_list.dart';

/// Full-screen search over all meals by title, opened from the app bar's
/// search icon via `showSearch()`.
class MealSearchDelegate extends SearchDelegate<void> {
  Widget _buildMatches(BuildContext context) {
    final matches = dummyMeals
        .where((meal) => meal.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return MealsList(
      meals: matches,
      emptyMessage: query.isEmpty
          ? 'Start typing to search for a meal.'
          : 'No meals found for "$query".',
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) => [
        if (query.isNotEmpty)
          IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) => _buildMatches(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildMatches(context);
}
