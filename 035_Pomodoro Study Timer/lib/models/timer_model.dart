enum TimerStatus {
  stopped,
  running,
  paused,
}

class TimerModel {
  final int workDuration;
  final int breakDuration;
  final int longBreakDuration;
  final int sessionsBeforeLongBreak;
  final TimerStatus status;
  final int currentSession;
  final bool isWorkTime;
  final int remainingTime;

  const TimerModel({
    required this.workDuration,
    required this.breakDuration,
    required this.longBreakDuration,
    required this.sessionsBeforeLongBreak,
    required this.status,
    required this.currentSession,
    required this.isWorkTime,
    required this.remainingTime,
  });

  TimerModel copyWith({
    int? workDuration,
    int? breakDuration,
    int? longBreakDuration,
    int? sessionsBeforeLongBreak,
    TimerStatus? status,
    int? currentSession,
    bool? isWorkTime,
    int? remainingTime,
  }) {
    return TimerModel(
      workDuration: workDuration ?? this.workDuration,
      breakDuration: breakDuration ?? this.breakDuration,
      longBreakDuration: longBreakDuration ?? this.longBreakDuration,
      sessionsBeforeLongBreak: sessionsBeforeLongBreak ?? this.sessionsBeforeLongBreak,
      status: status ?? this.status,
      currentSession: currentSession ?? this.currentSession,
      isWorkTime: isWorkTime ?? this.isWorkTime,
      remainingTime: remainingTime ?? this.remainingTime,
    );
  }
}