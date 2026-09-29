import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/meal.dart';
import '../providers/favorites_provider.dart';
import '../screens/meal_detail_screen.dart';

/// One row in a meal list: image, title, quick facts (duration, complexity,
/// affordability) and a favorite toggle. Used on the category meals screen
/// and on the favorites screen, so favoriting/unfavoriting always looks and
/// behaves the same everywhere.
class MealItem extends StatelessWidget {
  const MealItem({super.key, required this.meal});

  final Meal meal;

  void _toggleFavorite(BuildContext context) async {
    final isNowFavorite =
        await context.read<FavoritesProvider>().toggleFavorite(meal);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(
            isNowFavorite ? 'Added to favorites.' : 'Removed from favorites.',
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    // context.watch rebuilds this widget whenever favorites change, so the
    // star icon stays in sync no matter where it was toggled from.
    final isFavorite = context.watch<FavoritesProvider>().isFavorite(meal.id);

    return Card(
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => MealDetailScreen(meal: meal)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                // The Hero tag matches the one on the detail screen, so the
                // image smoothly flies between the two screens.
                Hero(
                  tag: 'meal-image-${meal.id}',
                  child: CachedNetworkImage(
                    imageUrl: meal.imageUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const SizedBox(
                      height: 180,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => const SizedBox(
                      height: 180,
                      child: Center(child: Icon(Icons.broken_image_outlined)),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: _FavoriteButton(
                    isFavorite: isFavorite,
                    onPressed: () => _toggleFavorite(context),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _FactChip(icon: Icons.schedule, label: '${meal.duration} min'),
                      const SizedBox(width: 10),
                      _FactChip(icon: Icons.bar_chart, label: meal.complexity.label),
                      const SizedBox(width: 10),
                      _FactChip(icon: Icons.attach_money, label: meal.affordability.label),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FactChip extends StatelessWidget {
  const _FactChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({required this.isFavorite, required this.onPressed});

  final bool isFavorite;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: Colors.black45, shape: BoxShape.circle),
      child: IconButton(
        onPressed: onPressed,
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
          child: Icon(
            isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
            key: ValueKey(isFavorite),
            color: Colors.amber,
          ),
        ),
      ),
    );
  }
}
