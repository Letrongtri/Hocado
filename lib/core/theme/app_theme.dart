import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hocado/utils/page_transition.dart';

class AppTheme {
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFcae642),
    onPrimary: Color(0xFF1A1A1C),
    secondary: Colors.white,
    onSecondary: Color(0xFFC2C3C5),
    error: Color(0xffE03616),
    onError: Colors.white,
    surface: Color(0xffF8F7FC),
    onSurface: Color(0xFF17242A),
  );

  static TextTheme textTheme(ColorScheme colorScheme) {
    final headingFont = GoogleFonts.merriweatherSansTextTheme();

    return TextTheme(
      displayLarge: headingFont.displayLarge?.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: colorScheme.onPrimary,
      ),
      headlineMedium: headingFont.headlineMedium?.copyWith(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: colorScheme.onPrimary,
      ),
      headlineSmall: headingFont.headlineSmall?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: colorScheme.onPrimary,
      ),

      titleMedium: headingFont.titleMedium?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: colorScheme.onPrimary,
      ),

      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: colorScheme.onPrimary,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: colorScheme.onPrimary,
      ),

      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: colorScheme.secondary,
        letterSpacing: 0.8,
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

    // Transition
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.iOS: const HocadoPageTransitionBuilder(),
        TargetPlatform.android: const HocadoPageTransitionBuilder(),
      },
    ),
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFcae642),
    onPrimary: Colors.white,
    secondary: Color(0xFF252525), // Card chuyển sang màu xám đen
    onSecondary: Color(0xFFC2C3C5),
    error: Color(0xffCF6679), // Màu đỏ dịu cho dark mode
    onError: Colors.black,
    surface: Color(0xff121212), // Nền App chuyển sang đen
    onSurface: Colors.white,
  );

  static ThemeData get darkTheme => ThemeData(
    colorScheme: darkColorScheme,
    useMaterial3: true,
    scaffoldBackgroundColor: darkColorScheme.surface,

    // Tái sử dụng hàm textTheme cũ của bạn
    textTheme: textTheme(darkColorScheme),

    appBarTheme: AppBarTheme(
      backgroundColor: darkColorScheme.surface,
      foregroundColor: darkColorScheme.onPrimary, // Màu trắng
      elevation: 0,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkColorScheme.primary,
        foregroundColor: const Color(0xFF1A1A1C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    cardColor: darkColorScheme.secondary,

    // Transition
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.iOS: const HocadoZoomPageTransitionBuilder(),
        TargetPlatform.android: const HocadoZoomPageTransitionBuilder(),
      },
    ),
  );
}
