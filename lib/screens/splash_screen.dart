import 'package:flutter/material.dart';
import 'package:sandy_roots/screens/Login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // รอ 1 วินาที แล้วไปหน้า Mainlogin
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Mainlogin()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F3), // สีครีม
      body: Center(
        child: Image.asset(
          'assets/images/logosandroots.png',
          height: screenHeight * 0.5,
        ),
      ),
    );
  }
}
