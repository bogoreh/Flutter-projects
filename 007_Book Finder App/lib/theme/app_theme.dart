import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    colorScheme: ColorScheme.light(
      primary: Colors.deepPurple,
      secondary: Colors.amber,
      background: Colors.grey[50]!,
    ),
    useMaterial3: true,
    fontFamily: 'Poppins',
  );

  static final darkTheme = ThemeData(
    colorScheme: ColorScheme.dark(
      primary: Colors.deepPurple[300]!,
      secondary: Colors.amber[300]!,
      background: Colors.grey[900]!,
    ),
    useMaterial3: true,
    fontFamily: 'Poppins',
  );
}