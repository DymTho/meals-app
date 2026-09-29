import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:meals_app/main.dart';

void main() {
  testWidgets('Shows the categories grid and can open a meal', (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const MealsApp());
    await tester.pumpAndSettle();

    // The home screen should show the category tiles (only the ones that
    // fit on screen are built, since the grid is lazy).
    expect(find.text('Italian'), findsOneWidget);
    expect(find.text('Quick & Easy'), findsOneWidget);

    // Opening a category should list its meals. We can't use pumpAndSettle
    // here: the meal photos show an indeterminate loading spinner while
    // there's no real network in tests, and that animation never settles.
    await tester.tap(find.text('Italian'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Margherita Pizza'), findsOneWidget);

    // Bottom nav should switch to the (initially empty) favorites screen.
    await tester.pageBack();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.text('Favorites'));
    await tester.pumpAndSettle();

    expect(find.textContaining('no favorite meals'), findsOneWidget);
  });
}
