import 'package:flutter/material.dart';

import '../models/category.dart';

/// One colored tile in the categories grid (home screen).
class CategoryGridItem extends StatelessWidget {
  const CategoryGridItem({super.key, required this.category, required this.onTap});

  final Category category;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      splashColor: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.3),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              category.color.withValues(alpha: 0.85),
              category.color.withValues(alpha: 0.55),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: category.color.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          category.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
    );
  }
}
