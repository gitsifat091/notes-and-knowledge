import 'package:flutter/material.dart';

class AppTheme {
  static const lightSurface = Color(0xFFE4E8EE);
  static const darkSurface = Color(0xFF272B33);
  static const accent = Color(0xFFC2502A);

  static ThemeData _build({required bool dark}) {
    final surface = dark ? darkSurface : lightSurface;
    final ink = dark ? const Color(0xFFE8EBF0) : const Color(0xFF2D3340);
    final muted = dark ? const Color(0xFFA3ABB8) : const Color(0xFF545D6C);
    return ThemeData(
      useMaterial3: true, brightness: dark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: surface, colorScheme: ColorScheme.fromSeed(
        seedColor: dark ? const Color(0xFFFF8A5C) : accent,
        brightness: dark ? Brightness.dark : Brightness.light,
        surface: surface, onSurface: ink),
      textTheme: ThemeData(brightness: dark ? Brightness.dark : Brightness.light)
        .textTheme.apply(bodyColor: ink, displayColor: ink),
      appBarTheme: AppBarTheme(backgroundColor: surface, foregroundColor: ink, elevation: 0),
      cardColor: surface, dividerColor: dark ? const Color(0xFF454B57) : const Color(0xFFCBD1DA),
      inputDecorationTheme: InputDecorationTheme(
        filled: true, fillColor: dark ? const Color(0xFF1F2228) : const Color(0xFFD9DEE6),
        hintStyle: TextStyle(color: muted),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: dark ? const Color(0xFFFF8A5C) : const Color(0xFFA3421F), width: 2)),
      ),
    );
  }
  static ThemeData get light => _build(dark: false);
  static ThemeData get dark => _build(dark: true);
}
