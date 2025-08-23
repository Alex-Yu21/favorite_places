import 'package:favorite_places/screens/places.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('should add place and show it in the list', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: PlaceScreen())),
    );
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('Title'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Test');

    expect(find.text('Add Place'), findsOneWidget);
    await tester.tap(find.text('Add Place'));
    await tester.pumpAndSettle();

    expect(find.text('Test'), findsOneWidget);
  });
}
