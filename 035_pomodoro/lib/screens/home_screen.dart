import 'package:flutter/material.dart';
import '../providers/timer_provider.dart';
import '../widgets/circular_timer.dart';
import '../widgets/control_buttons.dart';
import '../widgets/settings_panel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showSettings = false;
  final TimerProvider _timerProvider = TimerProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Header
              _buildHeader(),
              const SizedBox(height: 40),
              
              // Timer Display
              Expanded(
                flex: 2,
                child: CircularTimer(
                  timerProvider: _timerProvider,
                  onToggleSettings: () {
                    setState(() {
                      _showSettings = !_showSettings;
                    });
                  },
                ),
              ),
              
              // Control Buttons
              Expanded(
                child: ControlButtons(
                  timerProvider: _timerProvider,
                  onShowSettings: () {
                    setState(() {
                      _showSettings = true;
                    });
                  },
                ),
              ),
              
              // Settings Panel
              if (_showSettings) ...[
                const SizedBox(height: 20),
                SettingsPanel(
                  timerProvider: _timerProvider,
                  onClose: () {
                    setState(() {
                      _showSettings = false;
                    });
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final timer = _timerProvider.timer;
    return Column(
      children: [
        Text(
          timer.isWorkTime ? 'Focus Time' : 'Break Time',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Session ${timer.currentSession} of ${timer.sessionsBeforeLongBreak}',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}