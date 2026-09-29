import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/favorites_provider.dart';
import 'providers/filters_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/tabs_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MealsApp());
}

/// Root widget. Wires up the three [ChangeNotifier]s (favorites, filters,
/// theme) with [MultiProvider] so any screen below can read or watch them
/// with `context.watch<T>()` / `context.read<T>()` without passing data
/// down through constructors manually.
class MealsApp extends StatelessWidget {
  const MealsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // `..load()` starts reading saved favorites from disk right away;
        // the list starts empty and updates once loading finishes.
        ChangeNotifierProvider(create: (_) => FavoritesProvider()..load()),
        ChangeNotifierProvider(create: (_) => FiltersProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()..load()),
      ],
      // Consumer rebuilds just the MaterialApp when the theme changes,
      // instead of rebuilding the whole provider tree.
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          final seedColor = themeProvider.preset.seedColor;
          return MaterialApp(
            title: 'Meals App',
            debugShowCheckedModeBanner: false,
            theme: buildAppTheme(seedColor, Brightness.light),
            darkTheme: buildAppTheme(seedColor, Brightness.dark),
            themeMode: ThemeMode.system,
            home: const TabsScreen(),
          );
        },
      ),
    );
  }
}
