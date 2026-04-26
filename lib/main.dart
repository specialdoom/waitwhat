import 'package:flutter/material.dart';
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
      home: PermissionScreen(
        child: const Scaffold(
          body: Center(
            child: Text('WaitWhat'),
          ),
        ),
      ),
    );
  }
}