import 'package:flutter/material.dart';
import '../providers/timer_provider.dart';
import '../models/timer_model.dart';

class ControlButtons extends StatefulWidget {
  final TimerProvider timerProvider;
  final VoidCallback onShowSettings;

  const ControlButtons({
    super.key,
    required this.timerProvider,
    required this.onShowSettings,
  });

  @override
  State<ControlButtons> createState() => _ControlButtonsState();
}

class _ControlButtonsState extends State<ControlButtons> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.timerProvider,
      builder: (context, child) {
        final timer = widget.timerProvider.timer;
        
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Start/Pause Button
                _buildControlButton(
                  icon: timer.status == TimerStatus.running 
                      ? Icons.pause 
                      : Icons.play_arrow,
                  label: timer.status == TimerStatus.running ? 'Pause' : 'Start',
                  color: timer.isWorkTime ? Colors.deepPurple : Colors.green,
                  onPressed: () {
                    if (timer.status == TimerStatus.running) {
                      widget.timerProvider.pauseTimer();
                    } else {
                      widget.timerProvider.startTimer();
                    }
                  },
                ),
                
                // Reset Button
                _buildControlButton(
                  icon: Icons.refresh,
                  label: 'Reset',
                  color: Colors.grey,
                  onPressed: widget.timerProvider.resetTimer,
                ),
                
                // Skip Button
                _buildControlButton(
                  icon: Icons.skip_next,
                  label: 'Skip',
                  color: Colors.orange,
                  onPressed: () {
                    widget.timerProvider.resetTimer();
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Quick Settings Button
            ElevatedButton.icon(
              onPressed: widget.onShowSettings,
              icon: const Icon(Icons.timer),
              label: const Text('Timer Settings'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.deepPurple,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}