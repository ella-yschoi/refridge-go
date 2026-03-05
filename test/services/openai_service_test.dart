import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:refridge_go/models/ingredient.dart';
import 'package:refridge_go/models/cooking_tool.dart';
import 'package:refridge_go/models/recipe.dart';
import 'package:refridge_go/services/openai_service.dart';

void main() {
  late OpenAIService service;

  setUp(() {
    service = OpenAIService();
    dotenv.testLoad(fileInput: 'OPENAI_API_KEY=test-key-123');
  });

  tearDown(() {
    service.httpClient = null;
  });

  group('parseRecipeResponse', () {
    test('parses valid JSON response', () {
      final jsonStr = jsonEncode({
        'menu': 'Stir Fry',
        'description': 'Quick veggie stir fry',
        'steps': ['Heat oil', 'Add vegetables', 'Season'],
        'cookingTime': 15,
        'servings': 2,
        'difficulty': 'Easy',
        'ingredients': ['1 cup broccoli', '1 tbsp soy sauce'],
        'tools': ['Frying pan'],
      });

      final recipe = service.parseRecipeResponse(jsonStr);

      expect(recipe.menu, 'Stir Fry');
      expect(recipe.description, 'Quick veggie stir fry');
      expect(recipe.steps.length, 3);
      expect(recipe.cookingTime, 15);
      expect(recipe.ingredients.length, 2);
    });

    test('parses JSON wrapped in markdown code block', () {
      final content = '''
Here is your recipe:

```json
{
  "menu": "Pasta Carbonara",
  "description": "Classic Italian pasta",
  "steps": ["Cook pasta", "Mix eggs and cheese", "Combine"],
  "cookingTime": 20,
  "servings": 2,
  "difficulty": "Medium",
  "ingredients": ["200g spaghetti", "2 eggs"],
  "tools": ["Pot"]
}
```
''';

      final recipe = service.parseRecipeResponse(content);

      expect(recipe.menu, 'Pasta Carbonara');
      expect(recipe.steps.length, 3);
    });

    test('parses JSON wrapped in plain code block', () {
      final content = '''
```
{"menu": "Toast", "description": "Simple toast", "steps": ["Toast bread"], "cookingTime": 5, "servings": 1, "difficulty": "Easy", "ingredients": ["2 slices bread"], "tools": ["Oven"]}
```
''';

      final recipe = service.parseRecipeResponse(content);

      expect(recipe.menu, 'Toast');
    });

    test('falls back to text recipe on invalid JSON', () {
      const content = 'Here is a recipe: Cook some pasta with sauce.';

      final recipe = service.parseRecipeResponse(content);

      expect(recipe.menu, 'AI Recipe');
      expect(recipe.steps, isNotEmpty);
    });
  });

  group('generateRecipe', () {
    test('sends correct request and returns parsed recipe', () async {
      final mockResponse = jsonEncode({
        'choices': [
          {
            'message': {
              'content': jsonEncode({
                'menu': 'Egg Fried Rice',
                'description': 'Simple fried rice with eggs',
                'steps': ['Cook rice', 'Scramble eggs', 'Mix together'],
                'cookingTime': 20,
                'servings': 2,
                'difficulty': 'Easy',
                'ingredients': ['2 cups rice', '2 eggs', '1 tbsp soy sauce'],
                'tools': ['Frying pan'],
              }),
            }
          }
        ],
      });

      service.httpClient = MockClient((request) async {
        expect(request.url.toString(),
            'https://api.openai.com/v1/chat/completions');
        expect(request.headers['Authorization'], 'Bearer test-key-123');
        expect(request.headers['Content-Type'], contains('application/json'));

        final body = jsonDecode(request.body);
        expect(body['model'], isNotEmpty);
        expect(body['messages'][0]['content'], contains('Eggs'));
        expect(body['messages'][0]['content'], contains('Frying pan'));
        expect(body['messages'][0]['content'], contains('Easy'));

        return http.Response(mockResponse, 200);
      });

      final recipe = await service.generateRecipe(
        ingredients: [
          Ingredient(name: 'Eggs', isSelected: true),
          Ingredient(name: 'Rice', isSelected: true),
          Ingredient(name: 'Tomato', isSelected: false),
        ],
        tool: const CookingTool(name: 'Frying pan', icon: '🍳'),
        difficulty: Difficulty.easy,
      );

      expect(recipe.menu, 'Egg Fried Rice');
      expect(recipe.cookingTime, 20);
      expect(recipe.ingredients.length, 3);
    });

    test('throws on API error status', () async {
      service.httpClient = MockClient((request) async {
        return http.Response('{"error": "rate limited"}', 429);
      });

      expect(
        () => service.generateRecipe(
          ingredients: [Ingredient(name: 'Eggs', isSelected: true)],
          tool: const CookingTool(name: 'Pot', icon: '🥘'),
          difficulty: Difficulty.easy,
        ),
        throwsException,
      );
    });

    test('throws when no API key is set', () async {
      dotenv.testLoad(fileInput: '');

      expect(
        () => service.generateRecipe(
          ingredients: [Ingredient(name: 'Eggs', isSelected: true)],
          tool: const CookingTool(name: 'Pot', icon: '🥘'),
          difficulty: Difficulty.easy,
        ),
        throwsException,
      );
    });

    test('throws when no ingredients are selected', () async {
      expect(
        () => service.generateRecipe(
          ingredients: [Ingredient(name: 'Eggs', isSelected: false)],
          tool: const CookingTool(name: 'Pot', icon: '🥘'),
          difficulty: Difficulty.easy,
        ),
        throwsException,
      );
    });
  });
}
