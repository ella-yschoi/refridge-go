import '../models/cooking_tool.dart';

class Constants {
  // Ingredient categories (sorted alphabetically)
  static const Map<String, List<String>> ingredientCategories = {
    'Vegetables': [
      'Asparagus',
      'Broccoli',
      'Cabbage',
      'Carrots',
      'Corn',
      'Cucumber',
      'Eggplant',
      'Garlic',
      'Green Beans',
      'Lettuce',
      'Mushrooms',
      'Onions',
      'Peppers',
      'Potato',
      'Spinach',
      'Sweet Potato',
      'Tomatoes',
      'Zucchini',
    ],
    'Dairy': [
      'Butter',
      'Cheese',
      'Cream',
      'Milk',
      'Yogurt',
    ],
    'Proteins': [
      'Beef',
      'Chicken',
      'Eggs',
      'Fish',
      'Pork',
      'Shrimp',
      'Tofu',
    ],
    'Grains & Pasta': [
      'Bread',
      'Flour',
      'Noodles',
      'Pasta',
      'Quinoa',
      'Rice',
    ],
    'Pantry': [
      'Honey',
      'Olive Oil',
      'Pepper',
      'Salt',
      'Soy Sauce',
      'Sugar',
      'Vinegar',
    ],
  };

  // Common cooking tools (sorted alphabetically)
  static const List<CookingTool> commonTools = [
    CookingTool(name: 'Air Fryer', icon: '💨'),
    CookingTool(name: 'Blender', icon: '🌀'),
    CookingTool(name: 'Frying pan', icon: '🍳'),
    CookingTool(name: 'Grill', icon: '🍖'),
    CookingTool(name: 'Microwave', icon: '📻'),
    CookingTool(name: 'No special tools', icon: '✋'),
    CookingTool(name: 'Oven', icon: '🍳'),
    CookingTool(name: 'Pot', icon: '🥘'),
    CookingTool(name: 'Stove', icon: '🔥'),
  ];

  // API configuration
  static const String openAIModel = 'gpt-3.5-turbo';
  static const int maxTokens = 500;
}
