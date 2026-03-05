import 'package:flutter_test/flutter_test.dart';
import 'package:refridge_go/models/recipe.dart';
import 'package:refridge_go/models/cooking_tool.dart';

void main() {
  group('Recipe', () {
    test('fromJson creates Recipe with all fields', () {
      final json = {
        'menu': 'Tomato Pasta',
        'description': 'A simple pasta dish',
        'steps': ['Boil water', 'Cook pasta', 'Add sauce'],
        'cookingTime': 25,
        'servings': 2,
        'difficulty': 'Easy',
        'ingredients': ['200g pasta', '2 tomatoes', '1 tbsp olive oil'],
        'tools': ['Pot', 'Stove'],
      };

      final recipe = Recipe.fromJson(json);

      expect(recipe.menu, 'Tomato Pasta');
      expect(recipe.description, 'A simple pasta dish');
      expect(recipe.steps, ['Boil water', 'Cook pasta', 'Add sauce']);
      expect(recipe.cookingTime, 25);
      expect(recipe.servings, 2);
      expect(recipe.difficulty, Difficulty.easy);
      expect(recipe.ingredients, ['200g pasta', '2 tomatoes', '1 tbsp olive oil']);
      expect(recipe.tools, ['Pot', 'Stove']);
    });

    test('fromJson uses defaults for missing optional fields', () {
      final json = {
        'menu': 'Simple Dish',
        'description': 'A dish',
        'steps': ['Step 1'],
      };

      final recipe = Recipe.fromJson(json);

      expect(recipe.menu, 'Simple Dish');
      expect(recipe.cookingTime, 30);
      expect(recipe.servings, 4);
      expect(recipe.difficulty, Difficulty.medium);
      expect(recipe.ingredients, isEmpty);
      expect(recipe.tools, isEmpty);
    });

    test('fromJson handles null menu and description', () {
      final json = <String, dynamic>{};

      final recipe = Recipe.fromJson(json);

      expect(recipe.menu, 'Unknown Menu');
      expect(recipe.description, '');
      expect(recipe.steps, isEmpty);
    });

    test('fromJson handles invalid difficulty gracefully', () {
      final json = {
        'menu': 'Test',
        'description': 'Test',
        'steps': [],
        'difficulty': 'Impossible',
      };

      final recipe = Recipe.fromJson(json);

      expect(recipe.difficulty, Difficulty.medium);
    });

    test('toJson produces correct map', () {
      final recipe = Recipe(
        menu: 'Fried Rice',
        description: 'Stir-fried rice',
        steps: ['Cook rice', 'Stir fry'],
        cookingTime: 20,
        servings: 3,
        difficulty: Difficulty.easy,
        ingredients: ['2 cups rice', '1 egg'],
        tools: ['Frying pan'],
      );

      final json = recipe.toJson();

      expect(json['menu'], 'Fried Rice');
      expect(json['description'], 'Stir-fried rice');
      expect(json['steps'], ['Cook rice', 'Stir fry']);
      expect(json['cookingTime'], 20);
      expect(json['servings'], 3);
      expect(json['difficulty'], 'Easy');
      expect(json['ingredients'], ['2 cups rice', '1 egg']);
      expect(json['tools'], ['Frying pan']);
    });

    test('toJson and fromJson are reversible', () {
      final original = Recipe(
        menu: 'Grilled Chicken',
        description: 'Juicy grilled chicken',
        steps: ['Season', 'Grill 10 min each side', 'Rest 5 min'],
        cookingTime: 30,
        servings: 4,
        difficulty: Difficulty.hard,
        ingredients: ['500g chicken breast', '2 tbsp olive oil', 'Salt'],
        tools: ['Grill'],
      );

      final json = original.toJson();
      final restored = Recipe.fromJson(json);

      expect(restored.menu, original.menu);
      expect(restored.description, original.description);
      expect(restored.steps, original.steps);
      expect(restored.cookingTime, original.cookingTime);
      expect(restored.servings, original.servings);
      expect(restored.difficulty, original.difficulty);
      expect(restored.ingredients, original.ingredients);
      expect(restored.tools, original.tools);
    });
  });
}
