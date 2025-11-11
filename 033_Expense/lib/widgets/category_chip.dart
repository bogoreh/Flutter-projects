import 'package:flutter/material.dart';
import '../utils/colors.dart';

class CategoryChip extends StatelessWidget {
  final String category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  Color get _categoryColor {
    final Map<String, Color> colorMap = {
      'All': AppColors.primary,
      'Food': AppColors.food,
      'Transportation': AppColors.transportation,
      'Entertainment': AppColors.entertainment,
      'Shopping': AppColors.shopping,
      'Bills': AppColors.bills,
      'Healthcare': AppColors.healthcare,
      'Other': AppColors.other,
    };
    return colorMap[category] ?? AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? _categoryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? _categoryColor : AppColors.textSecondary.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Text(
          category,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}