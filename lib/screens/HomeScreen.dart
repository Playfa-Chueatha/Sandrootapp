
import 'package:flutter/material.dart';
import 'package:sandy_roots/screens/Login.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required DataUser userManager});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {

    
    return Scaffold(
      body: Center(
        child: OutlinedButton.icon(
          onPressed: () {
            // ไปหน้า "หน้าหลัก" หรือทำสิ่งที่ต้องการ
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Mainlogin()),
            );
          },
          icon: const Icon(Icons.home, color: Colors.green),
          label: const Text('หน้าหลัก'),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.green),
            foregroundColor: Colors.green,
          ),
        ),
      ),
    );
}}