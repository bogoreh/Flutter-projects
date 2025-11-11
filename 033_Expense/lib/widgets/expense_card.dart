import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../utils/colors.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;
  final VoidCallback onDelete;

  const ExpenseCard({
    super.key,
    required this.expense,
    required this.onDelete,
  });

  Map<String, dynamic> get _categoryInfo {
    final Map<String, Map<String, dynamic>> categoryData = {
      'Food': {
        'icon': Icons.restaurant,
        'color': AppColors.food,
      },
      'Transportation': {
        'icon': Icons.directions_car,
        'color': AppColors.transportation,
      },
      'Entertainment': {
        'icon': Icons.movie,
        'color': AppColors.entertainment,
      },
      'Shopping': {
        'icon': Icons.shopping_bag,
        'color': AppColors.shopping,
      },
      'Bills': {
        'icon': Icons.receipt,
        'color': AppColors.bills,
      },
      'Healthcare': {
        'icon': Icons.medical_services,
        'color': AppColors.healthcare,
      },
      'Other': {
        'icon': Icons.category,
        'color': AppColors.other,
      },
    };
    
    return categoryData[expense.category] ?? 
           categoryData['Other']!;
  }

  @override
  Widget build(BuildContext context) {
    final categoryInfo = _categoryInfo;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: categoryInfo['color'].withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            categoryInfo['icon'],
            color: categoryInfo['color'],
            size: 24,
          ),
        ),
        title: Text(
          expense.title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              expense.category,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
            if (expense.description != null) ...[
              const SizedBox(height: 2),
              Text(
                expense.description!,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${expense.amount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${expense.date.day}/${expense.date.month}/${expense.date.year}',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
        onLongPress: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete Expense?'),
              content: Text('Are you sure you want to delete "${expense.title}"?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    onDelete();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: AppColors.error),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}