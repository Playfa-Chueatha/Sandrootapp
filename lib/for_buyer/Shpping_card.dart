import 'package:flutter/material.dart';

class Shpping_card extends StatefulWidget {
  const Shpping_card({super.key});

  @override
  State<Shpping_card> createState() => _Shpping_cardState();
}

class _Shpping_cardState extends State<Shpping_card> {
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
        title: const Text("Shpping_card"),
        actions: [
          
        ],
      ),
    );
  }
}