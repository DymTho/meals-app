import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/dummy_data.dart';
import '../models/category.dart';
import '../providers/filters_provider.dart';
import '../widgets/category_grid_item.dart';
import 'meals_screen.dart';

/// Home screen: a grid of predefined categories (assignment req. 1).
/// Tiles fade and slide in one after another for a livelier first
/// impression instead of popping in all at once.
class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _openCategory(Category category) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => MealsScreen(category: category)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watching the filters here just to show a small "N filters active"
    // hint under the grid; the actual filtering happens on MealsScreen.
    final activeFilterCount =
        context.watch<FiltersProvider>().selectedFilters.values.where((v) => v).length;

    return Column(
      children: [
        if (activeFilterCount > 0)
          Container(
            width: double.infinity,
            color: Theme.of(context).colorScheme.primaryContainer,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              '$activeFilterCount dietary filter${activeFilterCount == 1 ? '' : 's'} active',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: availableCategories.length,
            itemBuilder: (context, index) {
              final category = availableCategories[index];
              // Stagger each tile's animation by a small delay based on its
              // index, so they cascade in instead of all appearing at once.
              final start = (index / availableCategories.length) * 0.6;
              final animation = CurvedAnimation(
                parent: _animationController,
                curve: Interval(start, start + 0.4, curve: Curves.easeOut),
              );
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.2),
                    end: Offset.zero,
                  ).animate(animation),
                  child: CategoryGridItem(
                    category: category,
                    onTap: () => _openCategory(category),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
