import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onTeam1Increment;
  final VoidCallback onTeam2Increment;
  final VoidCallback onReset;

  const ActionButtons({
    super.key,
    required this.onTeam1Increment,
    required this.onTeam2Increment,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          icon: Icons.add,
          label: 'Team 1 +1',
          color: Colors.blue,
          onPressed: onTeam1Increment,
        ),
        _buildActionButton(
          icon: Icons.refresh,
          label: 'Reset',
          color: Colors.grey,
          onPressed: onReset,
        ),
        _buildActionButton(
          icon: Icons.add,
          label: 'Team 2 +1',
          color: Colors.red,
          onPressed: onTeam2Increment,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon, color: Colors.white),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}