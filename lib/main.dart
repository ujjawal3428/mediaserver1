import 'package:flutter/material.dart';
import 'package:media_server/widgets/home.dart';
import 'theme.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Media Server',
      theme: fancyTheme,
      home: const HomeScreen(),
    );
  }
}
