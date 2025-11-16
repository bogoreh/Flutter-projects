import 'package:flutter/material.dart';
import '../models/timer_model.dart';

class TimerProvider with ChangeNotifier {
  TimerModel _timer = TimerModel(
    workDuration: 25 * 60, // 25 minutes
    breakDuration: 5 * 60, // 5 minutes
    longBreakDuration: 15 * 60, // 15 minutes
    sessionsBeforeLongBreak: 4,
    status: TimerStatus.stopped,
    currentSession: 1,
    isWorkTime: true,
    remainingTime: 25 * 60,
  );

  TimerModel get timer => _timer;

  void startTimer() {
    _timer = _timer.copyWith(status: TimerStatus.running);
    notifyListeners();
    _tick();
  }

  void pauseTimer() {
    _timer = _timer.copyWith(status: TimerStatus.paused);
    notifyListeners();
  }

  void resetTimer() {
    _timer = _timer.copyWith(
      status: TimerStatus.stopped,
      remainingTime: _timer.isWorkTime ? _timer.workDuration : _getBreakDuration(),
    );
    notifyListeners();
  }

  void _tick() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_timer.status == TimerStatus.running) {
        if (_timer.remainingTime > 0) {
          _timer = _timer.copyWith(remainingTime: _timer.remainingTime - 1);
          notifyListeners();
          _tick();
        } else {
          _switchSession();
        }
      }
    });
  }

  void _switchSession() {
    if (_timer.isWorkTime) {
      // Work session completed
      if (_timer.currentSession >= _timer.sessionsBeforeLongBreak) {
        // Long break
        _timer = _timer.copyWith(
          isWorkTime: false,
          remainingTime: _timer.longBreakDuration,
          currentSession: 1,
        );
      } else {
        // Short break
        _timer = _timer.copyWith(
          isWorkTime: false,
          remainingTime: _timer.breakDuration,
          currentSession: _timer.currentSession + 1,
        );
      }
    } else {
      // Break completed, start work session
      _timer = _timer.copyWith(
        isWorkTime: true,
        remainingTime: _timer.workDuration,
      );
    }
    
    _timer = _timer.copyWith(status: TimerStatus.stopped);
    notifyListeners();
    
    // Show completion message
    _showSessionCompleteMessage();
  }

  int _getBreakDuration() {
    return _timer.currentSession >= _timer.sessionsBeforeLongBreak
        ? _timer.longBreakDuration
        : _timer.breakDuration;
  }

  void _showSessionCompleteMessage() {
    debugPrint('Session completed! ${_timer.isWorkTime ? 'Break time!' : 'Work time!'}');
  }

  void updateSettings({
    int? workDuration,
    int? breakDuration,
    int? longBreakDuration,
    int? sessionsBeforeLongBreak,
  }) {
    _timer = _timer.copyWith(
      workDuration: workDuration ?? _timer.workDuration,
      breakDuration: breakDuration ?? _timer.breakDuration,
      longBreakDuration: longBreakDuration ?? _timer.longBreakDuration,
      sessionsBeforeLongBreak: sessionsBeforeLongBreak ?? _timer.sessionsBeforeLongBreak,
      remainingTime: _timer.isWorkTime 
          ? (workDuration ?? _timer.workDuration)
          : _getBreakDuration(),
    );
    notifyListeners();
  }
}