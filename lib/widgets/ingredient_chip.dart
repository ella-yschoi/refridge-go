import 'package:flutter/material.dart';
import '../models/ingredient.dart';
import '../utils/theme.dart';

/// Widget for displaying and selecting ingredients as chips
class IngredientChip extends StatelessWidget {
  final Ingredient ingredient;
  final VoidCallback onTap;

  const IngredientChip({
    super.key,
    required this.ingredient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: ingredient.isSelected
              ? (isDark 
                  ? AppTheme.primaryOrange.withOpacity(0.3)
                  : AppTheme.primaryOrange.withOpacity(0.15))
              : (isDark ? AppTheme.darkCard : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: ingredient.isSelected
                ? AppTheme.primaryOrange
                : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
            width: ingredient.isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          ingredient.name,
          style: TextStyle(
            fontSize: 14,
            fontWeight: ingredient.isSelected ? FontWeight.w600 : FontWeight.normal,
            color: ingredient.isSelected
                ? (isDark ? AppTheme.primaryOrange : AppTheme.primaryOrange)
                : (isDark ? Colors.white : Colors.black87),
          ),
        ),
      ),
    );
  }
}

