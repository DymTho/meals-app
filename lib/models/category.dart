import 'package:flutter/material.dart';

/// A predefined meal category shown on the home screen (e.g. Italian,
/// Breakfast, Summer). Categories are hardcoded in `data/dummy_data.dart`
/// since the assignment does not require a category-editing feature.
class Category {
  const Category({
    required this.id,
    required this.title,
    required this.color,
  });

  final String id;
  final String title;

  /// Background color of the category tile in the grid.
  final Color color;
}
