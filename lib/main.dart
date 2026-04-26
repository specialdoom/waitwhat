import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/permission_screen.dart';
import 'services/database_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseService.initialize();
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
      ),
      home: const PermissionScreen(child: HomeScreen()),
    );
  }
}