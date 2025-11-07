import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe.dart';

/// Service for local storage using SharedPreferences
class StorageService {
  static const String _historyKey = 'recipe_history';

  /// Save recipe to history
  Future<void> saveRecipeToHistory(Recipe recipe) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getRecipeHistory();
    
    // Add new recipe to the beginning
    history.insert(0, recipe);
    
    // Keep only last 20 recipes
    if (history.length > 20) {
      history.removeRange(20, history.length);
    }
    
    final jsonList = history.map((r) => r.toJson()).toList();
    await prefs.setString(_historyKey, jsonEncode(jsonList));
  }

  /// Get recipe history
  Future<List<Recipe>> getRecipeHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_historyKey);
    
    if (jsonString == null) {
      return [];
    }
    
    try {
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList.map((json) => Recipe.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Clear recipe history
  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}

