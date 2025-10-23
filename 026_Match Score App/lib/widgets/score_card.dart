import 'package:flutter/material.dart';
import '../models/match.dart';
import 'team_display.dart';
import 'action_buttons.dart';

class ScoreCard extends StatelessWidget {
  final Match match;
  final VoidCallback onTeam1Score;
  final VoidCallback onTeam2Score;
  final VoidCallback onReset;

  const ScoreCard({
    super.key,
    required this.match,
    required this.onTeam1Score,
    required this.onTeam2Score,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final isTeam1Leading = match.team1Score > match.team2Score;
    final isTeam2Leading = match.team2Score > match.team1Score;
    final isTie = match.team1Score == match.team2Score;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade50,
            Colors.red.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Match Status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _getStatusColor(match.status),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              match.status.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Teams and Scores
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TeamDisplay(
                  teamName: match.team1Name,
                  score: match.team1Score,
                  isLeading: isTeam1Leading,
                  teamColor: Colors.blue,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // VS Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Text(
                  'VS',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              Expanded(
                child: TeamDisplay(
                  teamName: match.team2Name,
                  score: match.team2Score,
                  isLeading: isTeam2Leading,
                  teamColor: Colors.red,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Winner/Loser/Tie Display
          if (!isTie)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: (isTeam1Leading ? Colors.blue : Colors.red).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${isTeam1Leading ? match.team1Name : match.team2Name} is WINNING!',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isTeam1Leading ? Colors.blue : Colors.red,
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'IT\'S A TIE!',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ),
          
          const SizedBox(height: 24),
          
          // Action Buttons
          ActionButtons(
            onTeam1Increment: onTeam1Score,
            onTeam2Increment: onTeam2Score,
            onReset: onReset,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'live':
        return Colors.green;
      case 'finished':
        return Colors.red;
      case 'upcoming':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}