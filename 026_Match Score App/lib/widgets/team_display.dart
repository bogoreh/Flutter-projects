import 'package:flutter/material.dart';

class TeamDisplay extends StatelessWidget {
  final String teamName;
  final int score;
  final bool isLeading;
  final Color teamColor;

  const TeamDisplay({
    super.key,
    required this.teamName,
    required this.score,
    required this.isLeading,
    required this.teamColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: teamColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLeading ? teamColor : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: teamColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                teamName.substring(0, 1),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            teamName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            score.toString(),
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: teamColor,
            ),
          ),
        ],
      ),
    );
  }
}