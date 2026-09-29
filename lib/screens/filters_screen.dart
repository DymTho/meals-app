import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/filters_provider.dart';

/// The 4 dietary filter switches (assignment req. 6). Toggling a switch
/// updates [FiltersProvider], which every meal list is already listening to,
/// so the change is reflected immediately without navigating back.
class FiltersScreen extends StatelessWidget {
  const FiltersScreen({super.key});

  static const _filterInfo = {
    Filter.glutenFree: (
      title: 'Gluten-free',
      subtitle: 'Only include gluten-free meals.',
      icon: Icons.grain_rounded,
    ),
    Filter.lactoseFree: (
      title: 'Lactose-free',
      subtitle: 'Only include lactose-free meals.',
      icon: Icons.icecream_outlined,
    ),
    Filter.vegetarian: (
      title: 'Vegetarian',
      subtitle: 'Only include vegetarian meals.',
      icon: Icons.eco_rounded,
    ),
    Filter.vegan: (
      title: 'Vegan',
      subtitle: 'Only include vegan meals.',
      icon: Icons.spa_rounded,
    ),
  };

  @override
  Widget build(BuildContext context) {
    // context.watch here (instead of Consumer) rebuilds the whole screen
    // when a switch changes, which is fine since the screen is small.
    final filters = context.watch<FiltersProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Your Filters')),
      body: ListView(
        children: [
          for (final entry in _filterInfo.entries)
            SwitchListTile(
              value: filters.selectedFilters[entry.key]!,
              onChanged: (isChecked) =>
                  context.read<FiltersProvider>().setFilter(entry.key, isChecked),
              title: Text(entry.value.title),
              subtitle: Text(entry.value.subtitle),
              secondary: Icon(entry.value.icon),
            ),
        ],
      ),
    );
  }
}
