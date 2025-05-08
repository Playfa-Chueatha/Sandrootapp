import 'dart:async';
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
    
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Mainlogin()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFF9F7F3), // สีครีม
      body: Center(
        child: Image.asset(
              'assets/images/logosandroots.png', 
              height: screenHeight * 2,
            ),
      ),
    );
  }
}
