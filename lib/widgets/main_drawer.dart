import 'package:flutter/material.dart';

import '../screens/filters_screen.dart';
import '../screens/theme_screen.dart';

/// Side drawer with links to the secondary screens (Filters, Theme). The
/// primary Categories/Favorites navigation lives in the bottom nav bar
/// instead, matching the figures in the assignment.
class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required void Function() onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 26, color: Theme.of(context).colorScheme.primary),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Drawer(
      child: Column(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [colorScheme.primary, colorScheme.tertiary],
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Icon(Icons.set_meal_rounded, size: 40, color: colorScheme.onPrimary),
                      const SizedBox(width: 16),
                      Text(
                        'Meals App',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: colorScheme.onPrimary,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildListTile(
            context,
            icon: Icons.tune_rounded,
            title: 'Filters',
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const FiltersScreen()),
              );
            },
          ),
          _buildListTile(
            context,
            icon: Icons.palette_rounded,
            title: 'Theme',
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const ThemeScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
