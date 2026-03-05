import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:refridge_go/models/recipe.dart';
import 'package:refridge_go/models/cooking_tool.dart';
import 'package:refridge_go/services/storage_service.dart';

void main() {
  late StorageService storage;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    storage = StorageService();
  });

  Recipe _createRecipe(String name) {
    return Recipe(
      menu: name,
      description: 'Description of $name',
      steps: ['Step 1', 'Step 2'],
      cookingTime: 20,
      servings: 2,
      difficulty: Difficulty.easy,
      ingredients: ['Ingredient 1'],
      tools: ['Pot'],
    );
  }

  group('StorageService', () {
    test('returns empty list when no history exists', () async {
      final history = await storage.getRecipeHistory();

      expect(history, isEmpty);
    });

    test('saves and retrieves a recipe', () async {
      final recipe = _createRecipe('Test Recipe');

      await storage.saveRecipeToHistory(recipe);
      final history = await storage.getRecipeHistory();

      expect(history.length, 1);
      expect(history[0].menu, 'Test Recipe');
      expect(history[0].description, 'Description of Test Recipe');
      expect(history[0].steps, ['Step 1', 'Step 2']);
      expect(history[0].cookingTime, 20);
    });

    test('saves newest recipe first', () async {
      await storage.saveRecipeToHistory(_createRecipe('First'));
      await storage.saveRecipeToHistory(_createRecipe('Second'));

      final history = await storage.getRecipeHistory();

      expect(history.length, 2);
      expect(history[0].menu, 'Second');
      expect(history[1].menu, 'First');
    });

    test('limits history to 20 recipes', () async {
      for (int i = 0; i < 25; i++) {
        await storage.saveRecipeToHistory(_createRecipe('Recipe $i'));
      }

      final history = await storage.getRecipeHistory();

      expect(history.length, 20);
      expect(history[0].menu, 'Recipe 24');
    });

    test('clears all history', () async {
      await storage.saveRecipeToHistory(_createRecipe('Recipe A'));
      await storage.saveRecipeToHistory(_createRecipe('Recipe B'));

      await storage.clearHistory();
      final history = await storage.getRecipeHistory();

      expect(history, isEmpty);
    });

    test('preserves recipe fields through save/load cycle', () async {
      final recipe = Recipe(
        menu: 'Grilled Chicken',
        description: 'Juicy grilled chicken breast',
        steps: ['Season', 'Grill 10 min', 'Rest 5 min'],
        cookingTime: 25,
        servings: 4,
        difficulty: Difficulty.hard,
        ingredients: ['500g chicken', 'Salt', 'Pepper'],
        tools: ['Grill'],
      );

      await storage.saveRecipeToHistory(recipe);
      final history = await storage.getRecipeHistory();

      final loaded = history[0];
      expect(loaded.menu, recipe.menu);
      expect(loaded.description, recipe.description);
      expect(loaded.steps, recipe.steps);
      expect(loaded.cookingTime, recipe.cookingTime);
      expect(loaded.servings, recipe.servings);
      expect(loaded.difficulty, recipe.difficulty);
      expect(loaded.ingredients, recipe.ingredients);
      expect(loaded.tools, recipe.tools);
    });
  });
}
