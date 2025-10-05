import 'package:flutter/material.dart';
// import 'package:hocado/presentation/screens/common/splash_screen.dart';
import 'package:hocado/presentation/screens/home/home_screen.dart';
import 'package:hocado/presentation/theme/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hocado',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      // themeMode: ThemeMode.system,
      home: HomeScreen(),
    );
  }
}
