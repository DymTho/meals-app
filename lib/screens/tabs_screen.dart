import 'dart:math';

import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import '../widgets/main_drawer.dart';
import '../widgets/meal_search_delegate.dart';
import 'categories_screen.dart';
import 'favorites_screen.dart';
import 'meal_detail_screen.dart';

/// Root screen of the app: switches between Categories and Favorites via
/// the bottom navigation bar (assignment req. 7 - seamless navigation).
class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;

  static const _pages = [
    (title: 'Categories', screen: CategoriesScreen()),
    (title: 'Your Favorites', screen: FavoritesScreen()),
  ];

  void _selectPage(int index) {
    setState(() => _selectedPageIndex = index);
  }

  /// Picks a random meal and opens its detail screen directly - a playful
  /// shortcut for "I don't know what to cook today".
  void _surpriseMe() {
    final randomMeal = dummyMeals[Random().nextInt(dummyMeals.length)];
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => MealDetailScreen(meal: randomMeal)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activePage = _pages[_selectedPageIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(activePage.title),
        actions: [
          IconButton(
            onPressed: () => showSearch(context: context, delegate: MealSearchDelegate()),
            icon: const Icon(Icons.search),
            tooltip: 'Search meals',
          ),
        ],
      ),
      drawer: const MainDrawer(),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: KeyedSubtree(
          key: ValueKey(_selectedPageIndex),
          child: activePage.screen,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _surpriseMe,
        icon: const Icon(Icons.shuffle_rounded),
        label: const Text('Surprise me'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: _selectPage,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.star_rounded), label: 'Favorites'),
        ],
      ),
    );
  }
}
