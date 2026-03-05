import 'package:flutter_test/flutter_test.dart';
import 'package:refridge_go/models/ingredient.dart';

void main() {
  group('Ingredient', () {
    test('creates with default isSelected = false', () {
      final ingredient = Ingredient(name: 'Tomato');

      expect(ingredient.name, 'Tomato');
      expect(ingredient.isSelected, false);
    });

    test('copyWith toggles selection', () {
      final ingredient = Ingredient(name: 'Onion');
      final selected = ingredient.copyWith(isSelected: true);

      expect(selected.name, 'Onion');
      expect(selected.isSelected, true);
      // Original unchanged
      expect(ingredient.isSelected, false);
    });

    test('copyWith can change name', () {
      final ingredient = Ingredient(name: 'Potato');
      final renamed = ingredient.copyWith(name: 'Sweet Potato');

      expect(renamed.name, 'Sweet Potato');
      expect(renamed.isSelected, false);
    });

    test('copyWith with no args returns equivalent ingredient', () {
      final ingredient = Ingredient(name: 'Garlic', isSelected: true);
      final copy = ingredient.copyWith();

      expect(copy.name, 'Garlic');
      expect(copy.isSelected, true);
    });
  });
}
