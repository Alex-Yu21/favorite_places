import 'dart:io';

import 'package:favorite_places/providers/user_places.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserPlacesProvider', () {
    test('should add new place', () {
      final File image = File('path');
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(userPlacesProvider), isEmpty);

      container.read(userPlacesProvider.notifier).addPlace('Test', image);

      final list = container.read(userPlacesProvider);
      expect(list, hasLength(1));
      expect(list.first.title, 'Test');
    });
  });
}
