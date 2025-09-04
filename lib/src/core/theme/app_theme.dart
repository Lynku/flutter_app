import 'package:flutter/material.dart';
import 'package:flutter_app/src/core/theme/dark_theme.dart';
import 'package:flutter_app/src/core/theme/light_theme.dart';
import 'package:flutter_app/src/core/theme/color_blind_theme.dart';

enum AppThemeMode {
  system,
  light,
  dark,
  colorBlind,
}

extension AppThemeModeExtension on AppThemeMode {
  String toDisplayString() {
    switch (this) {
      case AppThemeMode.system:
        return 'System';
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
      case AppThemeMode.colorBlind:
        return 'Color Blind';
    }
  }
}

ThemeData getThemeData(AppThemeMode mode) {
  switch (mode) {
    case AppThemeMode.light:
      return lightTheme;
    case AppThemeMode.dark:
      return darkTheme;
    case AppThemeMode.colorBlind:
      return colorBlindTheme;
    case AppThemeMode.system:
    default:
      // Fallback to light theme if system theme is not explicitly handled or for default
      return lightTheme; 
  }
}