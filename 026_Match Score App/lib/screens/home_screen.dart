import 'package:flutter/material.dart';
import '../models/match.dart';
import '../widgets/score_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Match _currentMatch;

  @override
  void initState() {
    super.initState();
    _currentMatch = Match(
      team1Name: 'Team A',
      team2Name: 'Team B',
      team1Score: 0,
      team2Score: 0,
      status: 'Live',
      matchTime: DateTime.now(),
    );
  }

  void _incrementTeam1Score() {
    setState(() {
      _currentMatch = Match(
        team1Name: _currentMatch.team1Name,
        team2Name: _currentMatch.team2Name,
        team1Score: _currentMatch.team1Score + 1,
        team2Score: _currentMatch.team2Score,
        status: _currentMatch.status,
        matchTime: _currentMatch.matchTime,
      );
    });
  }

  void _incrementTeam2Score() {
    setState(() {
      _currentMatch = Match(
        team1Name: _currentMatch.team1Name,
        team2Name: _currentMatch.team2Name,
        team1Score: _currentMatch.team1Score,
        team2Score: _currentMatch.team2Score + 1,
        status: _currentMatch.status,
        matchTime: _currentMatch.matchTime,
      );
    });
  }

  void _resetScores() {
    setState(() {
      _currentMatch = Match(
        team1Name: _currentMatch.team1Name,
        team2Name: _currentMatch.team2Name,
        team1Score: 0,
        team2Score: 0,
        status: _currentMatch.status,
        matchTime: _currentMatch.matchTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Match Score',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // Settings functionality can be added here
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with match info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                children: [
                  Text(
                    '${_currentMatch.team1Name} vs ${_currentMatch.team2Name}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(_currentMatch.matchTime),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Score Card
            ScoreCard(
              match: _currentMatch,
              onTeam1Score: _incrementTeam1Score,
              onTeam2Score: _incrementTeam2Score,
              onReset: _resetScores,
            ),
            
            const SizedBox(height: 30),
            
            // Statistics Section
            _buildStatistics(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatistics() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          const Text(
            'Match Statistics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Total Points', 
                  (_currentMatch.team1Score + _currentMatch.team2Score).toString()),
              _buildStatItem('Point Difference', 
                  (_currentMatch.team1Score - _currentMatch.team2Score).abs().toString()),
              _buildStatItem('Status', _currentMatch.status),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}