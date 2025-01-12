import 'package:flutter/material.dart';
import 'package:media_server/widgets/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Media Server',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
