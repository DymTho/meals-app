import 'nutrition.dart';

/// How hard a recipe is to cook. Shown as a small badge on meal cards and
/// on the detail screen.
enum Complexity { simple, challenging, hard }

/// How expensive a recipe is. Shown next to [Complexity].
enum Affordability { affordable, pricey, luxurious }

extension ComplexityLabel on Complexity {
  String get label => switch (this) {
        Complexity.simple => 'Simple',
        Complexity.challenging => 'Challenging',
        Complexity.hard => 'Hard',
      };
}

extension AffordabilityLabel on Affordability {
  String get label => switch (this) {
        Affordability.affordable => 'Affordable',
        Affordability.pricey => 'Pricey',
        Affordability.luxurious => 'Luxurious',
      };
}

/// A single recipe: the app's core data model. All meals are hardcoded in
/// `data/dummy_data.dart`; nothing is fetched from a server.
class Meal {
  const Meal({
    required this.id,
    required this.categories,
    required this.title,
    required this.imageUrl,
    required this.ingredients,
    required this.steps,
    required this.duration,
    required this.complexity,
    required this.affordability,
    required this.servings,
    required this.nutrition,
    this.isGlutenFree = false,
    this.isLactoseFree = false,
    this.isVegan = false,
    this.isVegetarian = false,
  });

  final String id;

  /// A meal can belong to more than one category (e.g. a pizza is both
  /// "Italian" and "Quick & Easy"), so this is a list of category ids.
  final List<String> categories;
  final String title;
  final String imageUrl;
  final List<String> ingredients;
  final List<String> steps;

  /// Preparation time in minutes.
  final int duration;
  final Complexity complexity;
  final Affordability affordability;

  /// Default number of servings the ingredient list above is written for.
  /// Used by the servings calculator on the detail screen.
  final int servings;

  /// Calories and macros per serving, shown as "additional recipe
  /// information" (assignment requirement 3e).
  final NutritionFacts nutrition;

  final bool isGlutenFree;
  final bool isLactoseFree;
  final bool isVegan;
  final bool isVegetarian;
}
