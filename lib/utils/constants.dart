import '../models/cooking_tool.dart';

class Constants {
  // Common ingredients list
  static const List<String> commonIngredients = [
    'Onion',
    'Garlic',
    'Egg',
    'Rice cake',
    'Chicken',
    'Beef',
    'Pork',
    'Tofu',
    'Potato',
    'Carrot',
    'Cabbage',
    'Spinach',
    'Tomato',
    'Mushroom',
    'Cheese',
    'Butter',
    'Milk',
    'Flour',
    'Sugar',
    'Salt',
    'Pepper',
    'Soy sauce',
    'Sesame oil',
  ];

  // Common cooking tools
  static const List<CookingTool> commonTools = [
    CookingTool(name: 'Frying pan', icon: '🍳'),
    CookingTool(name: 'Pot', icon: '🥘'),
    CookingTool(name: 'Oven', icon: '🔥'),
    CookingTool(name: 'Microwave', icon: '📻'),
    CookingTool(name: 'Rice cooker', icon: '🍚'),
    CookingTool(name: 'Blender', icon: '🌪️'),
    CookingTool(name: 'Knife', icon: '🔪'),
    CookingTool(name: 'No special tools', icon: '✋'),
  ];

  // API configuration
  static const String openAIModel = 'gpt-3.5-turbo';
  static const int maxTokens = 500;
}
