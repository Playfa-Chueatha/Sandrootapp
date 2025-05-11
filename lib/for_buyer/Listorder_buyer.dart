import 'package:flutter/material.dart';

class Listorder_buyer extends StatefulWidget {
  const Listorder_buyer({super.key});

  @override
  State<Listorder_buyer> createState() => _Listorder_buyerState();
}

class _Listorder_buyerState extends State<Listorder_buyer> {
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
        title: const Text("Listorder_buyer"),
        actions: [
          
        ],
      ),
    );
  }
}