import 'package:flutter/material.dart';

// Example of a color-blind friendly theme (Deuteranomaly/Protanomaly friendly)
final ThemeData colorBlindTheme = ThemeData(
  brightness: Brightness.light, // Can be light or dark base
  primaryColor: const Color(0xFF0072B2), // Blue
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(
    secondary: const Color(0xFFD55E00), // Orange
    error: const Color(0xFFCC79A7), // Reddish-purple
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF0072B2),
    foregroundColor: Colors.white,
  ),
  // You would adjust other colors like text, background, etc., to ensure contrast and avoid problematic color pairs.
  // For a full implementation, consider using a dedicated color-blind safe palette.
);