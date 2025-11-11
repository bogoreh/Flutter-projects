import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../widgets/expense_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/category_chip.dart';
import '../utils/colors.dart';
import 'add_expense_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Expense> expenses = [];
  double totalExpenses = 0.0;
  String selectedCategory = 'All';

  final List<String> categories = [
    'All',
    'Food',
    'Transportation',
    'Entertainment',
    'Shopping',
    'Bills',
    'Healthcare',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _calculateTotal();
  }

  void _calculateTotal() {
    totalExpenses = expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  void _addExpense(Expense expense) {
    setState(() {
      expenses.add(expense);
      _calculateTotal();
    });
  }

  void _deleteExpense(String id) {
    setState(() {
      expenses.removeWhere((expense) => expense.id == id);
      _calculateTotal();
    });
  }

  List<Expense> get _filteredExpenses {
    if (selectedCategory == 'All') return expenses;
    return expenses.where((expense) => expense.category == selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Category Filter
            _buildCategoryFilter(),
            
            // Expenses List
            Expanded(
              child: _filteredExpenses.isEmpty
                  ? const EmptyState()
                  : _buildExpensesList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddExpenseScreen(
                onExpenseAdded: _addExpense,
              ),
            ),
          );
          if (result != null) {
            _addExpense(result);
          }
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Expenses',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${totalExpenses.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.account_balance_wallet_rounded,
                  color: AppColors.primary,
                  size: 32,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '${expenses.length} transactions this month',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: CategoryChip(
              category: categories[index],
              isSelected: selectedCategory == categories[index],
              onTap: () {
                setState(() {
                  selectedCategory = categories[index];
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildExpensesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredExpenses.length,
      itemBuilder: (context, index) {
        final expense = _filteredExpenses[index];
        return ExpenseCard(
          expense: expense,
          onDelete: () => _deleteExpense(expense.id),
        );
      },
    );
  }
}