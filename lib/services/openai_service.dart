import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/recipe.dart';
import '../models/ingredient.dart';
import '../models/cooking_tool.dart';
import '../utils/constants.dart';

/// Service for interacting with OpenAI API
class OpenAIService {
  static final OpenAIService _instance = OpenAIService._internal();
  factory OpenAIService() => _instance;
  OpenAIService._internal();

  String? get _apiKey => dotenv.env['OPENAI_API_KEY'];

  /// Generate recipe recommendation based on user inputs
  Future<Recipe> generateRecipe({
    required List<Ingredient> ingredients,
    required CookingTool tool,
    required Difficulty difficulty,
  }) async {
    if (_apiKey == null || _apiKey!.isEmpty) {
      throw Exception('OpenAI API key is not configured. Please check your .env file.');
    }

    final selectedIngredients = ingredients
        .where((ing) => ing.isSelected)
        .map((ing) => ing.name)
        .toList();

    if (selectedIngredients.isEmpty) {
      throw Exception('Please select at least one ingredient.');
    }

    final prompt = _buildPrompt(
      selectedIngredients,
      tool.name,
      difficulty.label,
    );

    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': Constants.openAIModel,
          'messages': [
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'max_tokens': Constants.maxTokens,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'] as String;
        return _parseRecipeResponse(content);
      } else {
        throw Exception(
          'Failed to generate recipe: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error calling OpenAI API: $e');
    }
  }

  /// Build the prompt for OpenAI API
  String _buildPrompt(
    List<String> ingredients,
    String tool,
    String difficulty,
  ) {
    return '''
You are an expert chef.
Suggest a recipe using the following ingredients and tools.

Ingredients: ${ingredients.join(', ')}
Tools: $tool
Difficulty: $difficulty

Return the result in JSON format:
{
  "menu": "menu name",
  "description": "short description of the dish",
  "steps": ["step 1", "step 2", "step 3"]
}
''';
  }

  /// Parse the response from OpenAI API
  Recipe _parseRecipeResponse(String content) {
    try {
      // Extract JSON from markdown code blocks if present
      String jsonString = content.trim();
      if (jsonString.contains('```json')) {
        jsonString = jsonString
            .split('```json')[1]
            .split('```')[0]
            .trim();
      } else if (jsonString.contains('```')) {
        jsonString = jsonString.split('```')[1].split('```')[0].trim();
      }

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return Recipe.fromJson(json);
    } catch (e) {
      // Fallback: create a simple recipe from the text
      return Recipe(
        menu: 'AI Recipe',
        description: content.length > 200 ? content.substring(0, 200) : content,
        steps: content.split('\n').where((line) => line.trim().isNotEmpty).toList(),
      );
    }
  }
}

