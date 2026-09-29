/// Matches a leading quantity in an ingredient string, e.g. "150g Tomato
/// sauce" -> amount "150", unit "g", name "Tomato sauce". Ingredients
/// without a leading number (like "Salt, pepper and olive oil") don't match.
final _quantityPattern =
    RegExp(r'^(\d+(?:\.\d+)?)\s*(g|kg|ml|l|tbsp|tsp)?\s+(.+)$');

/// Scales the quantity at the start of [ingredient] by [factor], for the
/// servings calculator on the detail screen. Ingredients with no leading
/// number are returned unchanged.
///
/// Weight/volume units (g, kg, ml, l) round to whole numbers; everything
/// else (a plain count, tbsp, tsp) rounds to the nearest half, since those
/// are easier to measure by hand (e.g. "1.5 tbsp").
String scaleIngredient(String ingredient, double factor) {
  final match = _quantityPattern.firstMatch(ingredient);
  if (match == null) return ingredient;

  final amount = double.parse(match.group(1)!);
  final unit = match.group(2) ?? '';
  final name = match.group(3)!;
  final isWeightOrVolume = unit == 'g' || unit == 'kg' || unit == 'ml' || unit == 'l';

  final scaled = amount * factor;
  final rounded = isWeightOrVolume ? scaled.roundToDouble() : (scaled * 2).round() / 2;
  final amountLabel = rounded == rounded.roundToDouble()
      ? rounded.toInt().toString()
      : rounded.toStringAsFixed(1);

  if (unit.isEmpty) return '$amountLabel $name';
  if (isWeightOrVolume) return '$amountLabel$unit $name';
  return '$amountLabel $unit $name';
}
