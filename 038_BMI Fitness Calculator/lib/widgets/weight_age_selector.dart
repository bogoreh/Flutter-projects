import 'package:flutter/material.dart';

class WeightAgeSelector extends StatelessWidget {
  final double weight;
  final int age;
  final Function(double) onWeightChanged;
  final Function(int) onAgeChanged;

  const WeightAgeSelector({
    super.key,
    required this.weight,
    required this.age,
    required this.onWeightChanged,
    required this.onAgeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SelectorCard(
            title: 'Weight',
            value: weight.toInt(),
            unit: 'kg',
            color: Colors.green,
            onDecrement: () => onWeightChanged(weight - 1),
            onIncrement: () => onWeightChanged(weight + 1),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _SelectorCard(
            title: 'Age',
            value: age,
            unit: 'yrs',
            color: Colors.orange,
            onDecrement: () => onAgeChanged(age - 1),
            onIncrement: () => onAgeChanged(age + 1),
          ),
        ),
      ],
    );
  }
}

class _SelectorCard extends StatelessWidget {
  final String title;
  final int value;
  final String unit;
  final Color color;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _SelectorCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.color,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$value',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            unit,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _RoundButton(
                icon: Icons.remove,
                onPressed: onDecrement,
                color: color,
              ),
              const SizedBox(width: 20),
              _RoundButton(
                icon: Icons.add,
                onPressed: onIncrement,
                color: color,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;

  const _RoundButton({
    required this.icon,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: color.withOpacity(0.15),
      radius: 24,
      child: IconButton(
        icon: Icon(
          icon,
          color: color,
        ),
        onPressed: onPressed,
      ),
    );
  }
}