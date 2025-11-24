import 'package:flutter/material.dart';
import '../models/task_model.dart';

class AppTheme {
  static Color getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.done: return const Color(0xFF00C875); //Green
      case TaskStatus.stuck: return const Color(0xFFE2445C); //Red
      case TaskStatus.working: return const Color(0xFFFDAB3D); //Orange
      case TaskStatus.notStarted: return const Color(0xFFC4C4C4); //Grey
    }
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0073EA)), //Blue
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        iconTheme: IconThemeData(color: Colors.black),
      ),
    );
  }
}