import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WaitWhat',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00A884)),
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: kBrandGreen),
          actionsIconTheme: IconThemeData(color: kBrandGreen),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
