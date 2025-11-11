import 'package:flutter/material.dart';
import '../models/cooking_tool.dart';
import '../utils/constants.dart';

/// Widget for selecting cooking tools
class ToolSelector extends StatelessWidget {
  final CookingTool? selectedTool;
  final Function(CookingTool) onToolSelected;

  const ToolSelector({
    super.key,
    required this.selectedTool,
    required this.onToolSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.5,
      children: Constants.commonTools.map((tool) {
        final isSelected = selectedTool?.name == tool.name;
        return GestureDetector(
          onTap: () => onToolSelected(tool),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark
                  ? (isSelected ? const Color(0xFF3C5265) : const Color(0xFF2C3E50))
                  : (isSelected ? const Color(0xFFF5F5F5) : Colors.white),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
                    : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  tool.icon,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    tool.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

