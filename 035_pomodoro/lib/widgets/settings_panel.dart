import 'package:flutter/material.dart';
import '../providers/timer_provider.dart';

class SettingsPanel extends StatefulWidget {
  final TimerProvider timerProvider;
  final VoidCallback onClose;

  const SettingsPanel({
    super.key,
    required this.timerProvider,
    required this.onClose,
  });

  @override
  State<SettingsPanel> createState() => _SettingsPanelState();
}

class _SettingsPanelState extends State<SettingsPanel> {
  late int _workDuration;
  late int _breakDuration;
  late int _longBreakDuration;
  late int _sessionsBeforeLongBreak;

  @override
  void initState() {
    super.initState();
    final timer = widget.timerProvider.timer;
    _workDuration = timer.workDuration ~/ 60;
    _breakDuration = timer.breakDuration ~/ 60;
    _longBreakDuration = timer.longBreakDuration ~/ 60;
    _sessionsBeforeLongBreak = timer.sessionsBeforeLongBreak;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Timer Settings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: widget.onClose,
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Work Duration
          _buildSettingItem(
            'Work Duration',
            '$_workDuration min',
            _workDuration.toDouble(),
            (value) => setState(() => _workDuration = value.round()),
            1,
            60,
          ),
          
          // Break Duration
          _buildSettingItem(
            'Break Duration',
            '$_breakDuration min',
            _breakDuration.toDouble(),
            (value) => setState(() => _breakDuration = value.round()),
            1,
            30,
          ),
          
          // Long Break Duration
          _buildSettingItem(
            'Long Break',
            '$_longBreakDuration min',
            _longBreakDuration.toDouble(),
            (value) => setState(() => _longBreakDuration = value.round()),
            5,
            30,
          ),
          
          // Sessions before long break
          _buildSettingItem(
            'Sessions before Long Break',
            '$_sessionsBeforeLongBreak',
            _sessionsBeforeLongBreak.toDouble(),
            (value) => setState(() => _sessionsBeforeLongBreak = value.round()),
            2,
            8,
          ),
          
          const SizedBox(height: 20),
          
          // Save Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                'Save Settings',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    String title,
    String value,
    double currentValue,
    Function(double) onChanged,
    double min,
    double max,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Slider(
            value: currentValue,
            min: min,
            max: max,
            divisions: (max - min).round(),
            onChanged: onChanged,
            activeColor: Colors.deepPurple,
            inactiveColor: Colors.grey[300],
          ),
        ],
      ),
    );
  }

  void _saveSettings() {
    widget.timerProvider.updateSettings(
      workDuration: _workDuration * 60,
      breakDuration: _breakDuration * 60,
      longBreakDuration: _longBreakDuration * 60,
      sessionsBeforeLongBreak: _sessionsBeforeLongBreak,
    );
    widget.onClose();
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings saved successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}