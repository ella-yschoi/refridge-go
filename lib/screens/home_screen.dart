import 'package:flutter/material.dart';
import '../models/ingredient.dart';
import '../models/cooking_tool.dart';
import '../models/recipe.dart';
import '../services/openai_service.dart';
import '../utils/constants.dart';
import '../utils/theme.dart';
import '../widgets/ingredient_chip.dart';
import '../widgets/tool_selector.dart';
import '../widgets/difficulty_selector.dart';
import 'recipe_result_screen.dart';

/// Main screen for ingredient, tool, and difficulty selection
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, List<Ingredient>> _ingredientsByCategory = {};
  Map<String, bool> _expandedCategories = {};
  CookingTool? _selectedTool;
  Difficulty? _selectedDifficulty;
  bool _isLoading = false;
  
  static const int _maxVisibleItems = 8; // 최대 8개까지 보여주고 나머지는 토글

  @override
  void initState() {
    super.initState();
    _initializeIngredients();
  }

  void _initializeIngredients() {
    _ingredientsByCategory = {};
    _expandedCategories = {};
    Constants.ingredientCategories.forEach((category, ingredients) {
      _ingredientsByCategory[category] = ingredients
          .map((name) => Ingredient(name: name))
          .toList();
      _expandedCategories[category] = false; // 기본적으로 접혀있음
    });
  }
  
  void _toggleCategory(String category) {
    setState(() {
      _expandedCategories[category] = !_expandedCategories[category]!;
    });
  }

  void _toggleIngredient(String category, int index) {
    setState(() {
      final ingredients = _ingredientsByCategory[category]!;
      ingredients[index] = ingredients[index].copyWith(
        isSelected: !ingredients[index].isSelected,
      );
    });
  }

  bool _canGenerateRecipe() {
    final hasSelectedIngredients = _ingredientsByCategory.values
        .any((list) => list.any((ing) => ing.isSelected));
    return hasSelectedIngredients &&
        _selectedTool != null &&
        _selectedDifficulty != null &&
        !_isLoading;
  }

  List<Ingredient> _getSelectedIngredients() {
    final selected = <Ingredient>[];
    _ingredientsByCategory.values.forEach((list) {
      selected.addAll(list.where((ing) => ing.isSelected));
    });
    return selected;
  }

  Future<void> _generateRecipe() async {
    if (!_canGenerateRecipe()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final service = OpenAIService();
      final recipe = await service.generateRecipe(
        ingredients: _getSelectedIngredients(),
        tool: _selectedTool!,
        difficulty: _selectedDifficulty!,
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecipeResultScreen(recipe: recipe),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildCategorySection(String category) {
    final ingredients = _ingredientsByCategory[category]!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isExpanded = _expandedCategories[category] ?? false;
    final hasMoreItems = ingredients.length > _maxVisibleItems;
    final itemsToShow = hasMoreItems && !isExpanded ? _maxVisibleItems : ingredients.length;
    
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      constraints: const BoxConstraints(
        minHeight: 140,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            category,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(
              itemsToShow,
              (index) => IngredientChip(
                ingredient: ingredients[index],
                onTap: () => _toggleIngredient(category, index),
              ),
            ),
          ),
          if (hasMoreItems) ...[
            const SizedBox(height: 12),
            Center(
              child: TextButton.icon(
                onPressed: () => _toggleCategory(category),
                icon: Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  size: 20,
                ),
                label: Text(
                  isExpanded
                      ? 'Show less'
                      : 'Show ${ingredients.length - _maxVisibleItems} more',
                  style: const TextStyle(fontSize: 13),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.primaryOrange,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Section
          Text(
            'What\'s in your fridge?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              fontFamily: AppTheme.reservationWide,
            ),
          ),
          const SizedBox(height: 20),

          // Ingredients by Category
          ..._ingredientsByCategory.keys.map((category) {
            return _buildCategorySection(category);
          }),

          const SizedBox(height: 12),

          // Tools Section
          Text(
            'Available tools',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              fontFamily: AppTheme.reservationWide,
            ),
          ),
          const SizedBox(height: 12),
          ToolSelector(
            selectedTool: _selectedTool,
            onToolSelected: (tool) {
              setState(() {
                _selectedTool = tool;
              });
            },
          ),
          const SizedBox(height: 32),

          // Difficulty Section
          Text(
            'Difficulty level',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              fontFamily: AppTheme.reservationWide,
            ),
          ),
          const SizedBox(height: 12),
          DifficultySelector(
            selectedDifficulty: _selectedDifficulty,
            onDifficultySelected: (difficulty) {
              setState(() {
                _selectedDifficulty = difficulty;
              });
            },
          ),
          const SizedBox(height: 32),

          // Generate Button
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _canGenerateRecipe() ? _generateRecipe : null,
              icon: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.auto_awesome),
              label: Text(
                _isLoading ? 'Generating...' : 'Generate Recipe',
                style: TextStyle(
                  fontFamily: AppTheme.reservationWide,
                  fontWeight: FontWeight.w900,
                ),
              ),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

