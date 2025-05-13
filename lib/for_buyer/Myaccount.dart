import 'package:flutter/material.dart';
import 'package:sandy_roots/screens/Login.dart';

class Myaccount_buyer extends StatefulWidget {
  final DataUser userDetails;
  const Myaccount_buyer({super.key, required this.userDetails});

  @override
  State<Myaccount_buyer> createState() => _Myaccount_buyerState();
}

class _Myaccount_buyerState extends State<Myaccount_buyer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFA8D5BA),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Myaccount_buyer"),
        actions: [
          
        ],
      ),
    );
  }
}