import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sand Roots store',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Prompt',
        scaffoldBackgroundColor: const Color(0xFFF7F7F7),
      ),
      home: const SplashScreen(), // เริ่มจากหน้า splash ก่อน
    );
  }
}
