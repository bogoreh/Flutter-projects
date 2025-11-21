import 'package:flutter/material.dart';
import '../providers/timer_provider.dart';

class CircularTimer extends StatefulWidget {
  final TimerProvider timerProvider;
  final VoidCallback onToggleSettings;

  const CircularTimer({
    super.key,
    required this.timerProvider,
    required this.onToggleSettings,
  });

  @override
  State<CircularTimer> createState() => _CircularTimerState();
}

class _CircularTimerState extends State<CircularTimer> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.timerProvider,
      builder: (context, child) {
        final timer = widget.timerProvider.timer;
        final totalDuration = timer.isWorkTime 
            ? timer.workDuration 
            : (timer.currentSession >= timer.sessionsBeforeLongBreak 
                ? timer.longBreakDuration 
                : timer.breakDuration);
        final progress = 1 - (timer.remainingTime / totalDuration);
        
        return Stack(
          alignment: Alignment.center,
          children: [
            // Background Circle
            Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
            ),
            
            // Progress Circle
            SizedBox(
              width: 260,
              height: 260,
              child: CircularProgressIndicator(
                value: progress.toDouble(),
                strokeWidth: 8,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  timer.isWorkTime ? Colors.deepPurple : Colors.green,
                ),
              ),
            ),
            
            // Timer Text
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(timer.remainingTime),
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  timer.isWorkTime ? 'Stay Focused!' : 'Take a Break!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            
            // Settings Button
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                onPressed: widget.onToggleSettings,
                icon: Icon(
                  Icons.settings,
                  color: Colors.grey[600],
                  size: 28,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }
}