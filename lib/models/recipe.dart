import 'cooking_tool.dart';

class Recipe {
  final String menu;
  final String description;
  final List<String> steps;
  final int cookingTime; // in minutes
  final int servings;
  final Difficulty difficulty;
  final List<String> ingredients;
  final List<String> tools;

  Recipe({
    required this.menu,
    required this.description,
    required this.steps,
    this.cookingTime = 30,
    this.servings = 4,
    this.difficulty = Difficulty.medium,
    this.ingredients = const [],
    this.tools = const [],
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      menu: json['menu'] as String? ?? 'Unknown Menu',
      description: json['description'] as String? ?? '',
      steps: (json['steps'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      cookingTime: json['cookingTime'] as int? ?? 30,
      servings: json['servings'] as int? ?? 4,
      difficulty: json['difficulty'] != null
          ? Difficulty.values.firstWhere(
              (d) => d.label == json['difficulty'],
              orElse: () => Difficulty.medium,
            )
          : Difficulty.medium,
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      tools: (json['tools'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menu': menu,
      'description': description,
      'steps': steps,
      'cookingTime': cookingTime,
      'servings': servings,
      'difficulty': difficulty.label,
      'ingredients': ingredients,
      'tools': tools,
    };
  }
}

