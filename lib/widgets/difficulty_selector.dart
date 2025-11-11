import 'package:flutter/material.dart';
import '../models/cooking_tool.dart';

/// Widget for selecting difficulty level
class DifficultySelector extends StatelessWidget {
  final Difficulty? selectedDifficulty;
  final Function(Difficulty) onDifficultySelected;

  const DifficultySelector({
    super.key,
    required this.selectedDifficulty,
    required this.onDifficultySelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Row(
      children: Difficulty.values.map((difficulty) {
        final isSelected = selectedDifficulty == difficulty;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () => onDifficultySelected(difficulty),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFFFB800)
                      : (isDark ? const Color(0xFF2C3E50) : const Color(0xFFF5F5F5)),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFFFB800)
                        : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    difficulty.label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : (isDark ? Colors.white70 : Colors.black87),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

