import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';

/// Lets the user pick one of the color themes defined in [appThemePresets].
class ThemeScreen extends StatelessWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('App Theme')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final preset in appThemePresets)
            _ThemeOption(
              preset: preset,
              selected: themeProvider.themeId == preset.id,
              onTap: () => context.read<ThemeProvider>().selectTheme(preset.id),
            ),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({required this.preset, required this.selected, required this.onTap});

  final AppThemePreset preset;
  final bool selected;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
            border: Border.all(
              color: selected ? preset.seedColor : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: preset.seedColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: preset.seedColor.withValues(alpha: 0.5),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(preset.label, style: Theme.of(context).textTheme.titleMedium),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: selected
                    ? Icon(Icons.check_circle_rounded, key: const ValueKey('sel'), color: preset.seedColor)
                    : Icon(Icons.circle_outlined, key: const ValueKey('unsel'), color: colorScheme.onSurface.withValues(alpha: 0.3)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
