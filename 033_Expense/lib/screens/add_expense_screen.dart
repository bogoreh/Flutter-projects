import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../utils/colors.dart';

class AddExpenseScreen extends StatefulWidget {
  final Function(Expense) onExpenseAdded;

  const AddExpenseScreen({super.key, required this.onExpenseAdded});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedCategory = 'Food';
  DateTime _selectedDate = DateTime.now();

  final List<String> _categories = [
    'Food',
    'Transportation',
    'Entertainment',
    'Shopping',
    'Bills',
    'Healthcare',
    'Other'
  ];

  Map<String, Color> _categoryColors = {
    'Food': AppColors.food,
    'Transportation': AppColors.transportation,
    'Entertainment': AppColors.entertainment,
    'Shopping': AppColors.shopping,
    'Bills': AppColors.bills,
    'Healthcare': AppColors.healthcare,
    'Other': AppColors.other,
  };

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final expense = Expense(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        date: _selectedDate,
        category: _selectedCategory,
        description: _descriptionController.text.isEmpty 
            ? null 
            : _descriptionController.text,
      );

      widget.onExpenseAdded(expense);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Add Expense'),
        backgroundColor: AppColors.card,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _submitForm,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Title Field
              _buildTextField(
                controller: _titleController,
                label: 'Title',
                hintText: 'Enter expense title',
                icon: Icons.title,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Amount Field
              _buildTextField(
                controller: _amountController,
                label: 'Amount',
                hintText: '0.00',
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Category Selection
              _buildCategorySelector(),
              
              const SizedBox(height: 16),
              
              // Date Selection
              _buildDateSelector(),
              
              const SizedBox(height: 16),
              
              // Description Field
              _buildTextField(
                controller: _descriptionController,
                label: 'Description (Optional)',
                hintText: 'Enter description',
                icon: Icons.description,
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          prefixIcon: Icon(icon, color: AppColors.textSecondary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: AppColors.card,
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Category',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _categories.map((category) {
              return ChoiceChip(
                label: Text(category),
                selected: _selectedCategory == category,
                onSelected: (selected) {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
                backgroundColor: Colors.grey[200],
                selectedColor: _categoryColors[category]!.withOpacity(0.2),
                labelStyle: TextStyle(
                  color: _selectedCategory == category 
                      ? _categoryColors[category] 
                      : AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Text(
            'Date',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: _selectDate,
            child: Text(
              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}