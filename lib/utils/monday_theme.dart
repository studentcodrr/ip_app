import 'package:flutter/material.dart';
import '../models/task_model.dart';

class MondayTheme {
  static const Color greenDone = Color(0xFF00C875);
  static const Color orangeWorking = Color(0xFFFDAB3D);
  static const Color redStuck = Color(0xFFE2445C);
  static const Color greyEmpty = Color(0xFFC4C4C4);
  static const Color purple = Color(0xFFA25DDC);
  static const Color blue = Color(0xFF0073EA);

  static Color getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.done: return greenDone;
      case TaskStatus.working: return orangeWorking;
      case TaskStatus.stuck: return redStuck;
      case TaskStatus.notStarted: return greyEmpty;
    }
  }

  static Color getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.high: return redStuck;
      case Priority.medium: return purple;
      case Priority.low: return blue;
    }
  }
}