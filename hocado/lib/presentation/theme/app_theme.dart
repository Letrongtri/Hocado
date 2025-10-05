import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFcae642),
    onPrimary: Color(0xFF1A1A1C),
    secondary: Colors.white,
    onSecondary: Color(0xFFC2C3C5),
    error: Color(0xffE03616),
    onError: Colors.white,
    surface: Color(0xffF9F9Fa),
    onSurface: Color(0xFF17242A),
  );

  static TextTheme textTheme(ColorScheme colorScheme) {
    final headingFont = GoogleFonts.notoSansTextTheme();

    return TextTheme(
      displayLarge: headingFont.displayLarge?.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: colorScheme.onPrimary,
      ),
      headlineMedium: headingFont.headlineMedium?.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
      ),
      headlineSmall: headingFont.headlineSmall?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      titleMedium: headingFont.titleMedium?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),

      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: colorScheme.onPrimary,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: colorScheme.onPrimary.withAlpha(122),
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSecondary,
      ),
    );
  }

  static ThemeData get lightTheme => ThemeData(
    colorScheme: lightColorScheme,
    useMaterial3: true,
    scaffoldBackgroundColor: lightColorScheme.surface,
    textTheme: textTheme(lightColorScheme),
    appBarTheme: AppBarTheme(
      backgroundColor: lightColorScheme.surface,
      foregroundColor: lightColorScheme.onPrimary,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: lightColorScheme.primary,
        foregroundColor: lightColorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    cardColor: lightColorScheme.secondary,
  );
}
