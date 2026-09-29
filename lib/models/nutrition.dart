/// Nutrition facts for one serving of a meal. Shown in the "Additional
/// recipe information" section of the detail screen (assignment req. 3e).
class NutritionFacts {
  const NutritionFacts({
    required this.calories,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
  });

  final int calories;
  final int proteinGrams;
  final int carbsGrams;
  final int fatGrams;
}
