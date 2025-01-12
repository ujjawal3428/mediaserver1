import 'package:flutter/material.dart';
import 'package:media_server/widgets/home.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  print("Starting app..."); 
  runApp(const MyApp()); 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print("Building MyApp..."); 
    return MaterialApp(
      title: 'My Flutter App',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      home: const HomeScreen(), 
    );
  }
}