import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  colorScheme: lightColorScheme,
  fontFamily: 'Lato',
  textTheme: lightTextScheme,
);
final darkTheme = ThemeData(
  colorScheme: darkColorScheme,
  fontFamily: 'Lato',
  textTheme: darkTextScheme,
);

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF2D5DAA),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFD7E2FF),
  onPrimaryContainer: Color(0xFF001A40),
  secondary: Color(0xFF002E69),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFD8E2FF),
  onSecondaryContainer: Color(0xFF001A41),
  tertiary: Color(0xFF715574),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFFBD7FC),
  onTertiaryContainer: Color(0xFF29132D),
  error: Color(0xFFBA1A1A),
  errorContainer: Color(0xFFFFDAD6),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410002),
  background: Color(0xFFFEFBFF),
  onBackground: Color(0xFF1B1B1F),
  surface: Color(0xFFFEFBFF),
  onSurface: Color(0xFF1B1B1F),
  surfaceVariant: Color(0xFFE1E2EC),
  onSurfaceVariant: Color(0xFF44474F),
  outline: Color(0xFF74777F),
  onInverseSurface: Color(0xFFF2F0F4),
  inverseSurface: Color(0xFF2F3033),
  inversePrimary: Color(0xFFACC7FF),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF2D5DAA),
);

final lightTextScheme = TextTheme(
  titleLarge: TextStyle(fontSize: 108.0, color: lightColorScheme.onPrimary),
  titleMedium: TextStyle(fontSize: 56.0, color: lightColorScheme.onPrimary),
  displayMedium: TextStyle(
      fontSize: 502.0,
      fontWeight: FontWeight.bold,
      color: lightColorScheme.onPrimary),
  bodyLarge: TextStyle(fontSize: 44.0, color: lightColorScheme.error),
  bodyMedium: TextStyle(fontSize: 28.0, color: lightColorScheme.onPrimary),
  bodySmall: const TextStyle(fontSize: 20.0, color: Colors.black),
  labelSmall: TextStyle(
      fontSize: 18.0, color: lightColorScheme.outline, letterSpacing: 0.2),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFACC7FF),
  onPrimary: Color(0xFF002F68),
  primaryContainer: Color(0xFF054490),
  onPrimaryContainer: Color(0xFFD7E2FF),
  secondary: Color(0xFFADC6FF),
  onSecondary: Color(0xFF002E69),
  secondaryContainer: Color(0xFF0F448E),
  onSecondaryContainer: Color(0xFFD8E2FF),
  tertiary: Color(0xFFDEBCDF),
  onTertiary: Color(0xFF402844),
  tertiaryContainer: Color(0xFF583E5B),
  onTertiaryContainer: Color(0xFFFBD7FC),
  error: Color(0xFFFFB4AB),
  errorContainer: Color(0xFF93000A),
  onError: Color(0xFF690005),
  onErrorContainer: Color(0xFFFFDAD6),
  background: Color(0xFF1B1B1F),
  onBackground: Color(0xFFE3E2E6),
  surface: Color(0xFF1B1B1F),
  onSurface: Color(0xFFE3E2E6),
  surfaceVariant: Color(0xFF44474F),
  onSurfaceVariant: Color(0xFFC4C6D0),
  outline: Color(0xFF8E9099),
  onInverseSurface: Color(0xFF1B1B1F),
  inverseSurface: Color(0xFFE3E2E6),
  inversePrimary: Color(0xFF2D5DAA),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFFACC7FF),
);
final darkTextScheme = TextTheme(
  titleLarge: TextStyle(fontSize: 108.0, color: darkColorScheme.onPrimary),
  titleMedium: TextStyle(fontSize: 56.0, color: darkColorScheme.onPrimary),
  displayMedium: TextStyle(
      fontSize: 502.0,
      fontWeight: FontWeight.bold,
      color: lightColorScheme.onPrimary),
  bodyLarge: TextStyle(fontSize: 44.0, color: darkColorScheme.error),
  bodyMedium: TextStyle(fontSize: 28.0, color: darkColorScheme.onPrimary),
  bodySmall: TextStyle(fontSize: 20.0, color: darkColorScheme.onPrimary),
  labelSmall: TextStyle(
      fontSize: 18.0, color: darkColorScheme.outline, letterSpacing: 0.2),
);
