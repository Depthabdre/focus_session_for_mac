import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  const Color surface = Color(0xFF2D2E32);
  const Color bg = Color(0xFF1E1F23);

  final ColorScheme scheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF2CB0FF),
    brightness: Brightness.dark,
  );

  return ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    scaffoldBackgroundColor: bg,
    cardColor: surface,
    dividerColor: const Color(0xFF44464D),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        color: Color(0xFFF2F4F8),
      ),
      titleLarge: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        color: Color(0xFFF2F4F8),
      ),
      bodyLarge: TextStyle(
        fontSize: 17,
        height: 1.35,
        color: Color(0xFFE0E2E9),
      ),
      bodyMedium: TextStyle(
        fontSize: 15,
        height: 1.35,
        color: Color(0xFFBBC0CD),
      ),
    ),
  );
}
