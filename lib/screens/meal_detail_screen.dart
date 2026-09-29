import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/meal.dart';
import '../providers/favorites_provider.dart';
import '../utils/ingredient_scaler.dart';

/// Full recipe details (assignment req. 3): ingredients, steps, complexity,
/// affordability and nutrition facts, plus a servings calculator that
/// rescales ingredient quantities and a favorite toggle in the app bar.
class MealDetailScreen extends StatefulWidget {
  const MealDetailScreen({super.key, required this.meal});

  final Meal meal;

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  late int _currentServings = widget.meal.servings;

  void _changeServings(int delta) {
    setState(() {
      _currentServings = (_currentServings + delta).clamp(1, 20);
    });
  }

  Future<void> _toggleFavorite() async {
    final isNowFavorite =
        await context.read<FavoritesProvider>().toggleFavorite(widget.meal);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(isNowFavorite ? 'Added to favorites.' : 'Removed from favorites.'),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final meal = widget.meal;
    final colorScheme = Theme.of(context).colorScheme;
    final isFavorite = context.watch<FavoritesProvider>().isFavorite(meal.id);
    final servingsFactor = _currentServings / meal.servings;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            actions: [
              IconButton(
                onPressed: _toggleFavorite,
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
                  child: Icon(
                    isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                    key: ValueKey(isFavorite),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              // Always white with a shadow: this title sits on top of an
              // unpredictable food photo while expanded (not the app bar's
              // usual solid background), so it needs guaranteed contrast.
              title: Text(
                meal.title,
                style: const TextStyle(
                  color: Colors.white,
                  shadows: [Shadow(blurRadius: 8, color: Colors.black87)],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'meal-image-${meal.id}',
                    child: CachedNetworkImage(
                      imageUrl: meal.imageUrl,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.broken_image_outlined, size: 48),
                    ),
                  ),
                  // Darkens the bottom of the photo so the title stays
                  // readable no matter how bright the photo is.
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.5, 1],
                        colors: [Colors.transparent, Colors.black87],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _QuickFactsRow(meal: meal),
                  const SizedBox(height: 20),
                  if (meal.isGlutenFree || meal.isLactoseFree || meal.isVegan || meal.isVegetarian)
                    _DietaryTags(meal: meal),
                  const SizedBox(height: 20),
                  _SectionCard(
                    title: 'Ingredients',
                    trailing: _ServingsStepper(
                      servings: _currentServings,
                      onChanged: _changeServings,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final ingredient in meal.ingredients)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Icon(Icons.circle, size: 8, color: colorScheme.primary),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(scaleIngredient(ingredient, servingsFactor)),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SectionCard(
                    title: 'Steps',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final (index, step) in meal.steps.indexed)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor: colorScheme.primary,
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      color: colorScheme.onPrimary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(child: Text(step)),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SectionCard(
                    title: 'Additional Information',
                    // These values don't change with the servings stepper
                    // above: nutrition labels always describe one serving,
                    // just like on a real food package.
                    subtitle: 'Nutrition facts per serving',
                    child: _NutritionGrid(meal: meal),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickFactsRow extends StatelessWidget {
  const _QuickFactsRow({required this.meal});

  final Meal meal;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _QuickFact(icon: Icons.schedule, label: '${meal.duration} min')),
        Expanded(child: _QuickFact(icon: Icons.bar_chart, label: meal.complexity.label)),
        Expanded(child: _QuickFact(icon: Icons.attach_money, label: meal.affordability.label)),
      ],
    );
  }
}

class _QuickFact extends StatelessWidget {
  const _QuickFact({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: colorScheme.primaryContainer,
          child: Icon(icon, color: colorScheme.onPrimaryContainer),
        ),
        const SizedBox(height: 6),
        Text(label, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
      ],
    );
  }
}

class _DietaryTags extends StatelessWidget {
  const _DietaryTags({required this.meal});

  final Meal meal;

  @override
  Widget build(BuildContext context) {
    final tags = [
      if (meal.isVegan) 'Vegan',
      if (meal.isVegetarian) 'Vegetarian',
      if (meal.isGlutenFree) 'Gluten-free',
      if (meal.isLactoseFree) 'Lactose-free',
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final tag in tags)
          Chip(
            label: Text(tag),
            avatar: const Icon(Icons.eco_rounded, size: 18),
          ),
      ],
    );
  }
}

/// Lets the user pick how many servings to cook for. The word "servings"
/// is spelled out (not just a bare number) so it's clear this scales the
/// ingredient quantities below, not something else like a rating.
class _ServingsStepper extends StatelessWidget {
  const _ServingsStepper({required this.servings, required this.onChanged});

  final int servings;
  final void Function(int delta) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.people_alt_rounded,
          size: 18,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 6),
        IconButton(
          onPressed: () => onChanged(-1),
          icon: const Icon(Icons.remove_circle_outline),
          visualDensity: VisualDensity.compact,
        ),
        Text(
          '$servings serving${servings == 1 ? '' : 's'}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        IconButton(
          onPressed: () => onChanged(1),
          icon: const Icon(Icons.add_circle_outline),
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
    this.trailing,
    this.subtitle,
  });

  final String title;
  final Widget child;
  final Widget? trailing;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                ?trailing,
              ],
            ),
            if (subtitle != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _NutritionGrid extends StatelessWidget {
  const _NutritionGrid({required this.meal});

  final Meal meal;

  @override
  Widget build(BuildContext context) {
    final nutrition = meal.nutrition;
    final stats = [
      (icon: Icons.local_fire_department_rounded, label: 'Calories', value: '${nutrition.calories} kcal'),
      (icon: Icons.fitness_center_rounded, label: 'Protein', value: '${nutrition.proteinGrams} g'),
      (icon: Icons.grain_rounded, label: 'Carbs', value: '${nutrition.carbsGrams} g'),
      (icon: Icons.opacity_rounded, label: 'Fat', value: '${nutrition.fatGrams} g'),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 3,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        for (final stat in stats)
          DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Icon(stat.icon, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(stat.label, style: Theme.of(context).textTheme.labelSmall),
                      Text(stat.value, style: Theme.of(context).textTheme.titleSmall),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
