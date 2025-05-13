import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sandy_roots/data.dart';
import 'package:sandy_roots/for_buyer/Home.dart';
import 'package:sandy_roots/for_buyer/Listorder_buyer.dart';
import 'package:sandy_roots/for_buyer/Myaccount.dart';
import 'package:sandy_roots/for_buyer/Shpping_card.dart';
import 'package:sandy_roots/for_buyer/category.dart';
import 'package:sandy_roots/screens/Login.dart';

class AppbarBuyer extends StatefulWidget {
  final DataUser userDetails;
  final int selectedIndex;
  final String? selectedCategory;
  final Map<String, dynamic>? orderData;

  const AppbarBuyer({
    super.key,
    this.selectedIndex = 0,
    this.orderData,
    required this.userDetails, 
    this.selectedCategory,
  });

  @override
  State<AppbarBuyer> createState() => _AppbarBuyerState();
}

class _AppbarBuyerState extends State<AppbarBuyer> {
  List<Product> products = [];
  int _currentIndex = 0;
  late List<Widget> _pages;

  Future<void> productslist() async {
    try {
      final String response = await rootBundle.loadString('assets/data/Order.json');
      final data = json.decode(response) as List;
      setState(() {
        products = data.map((e) => Product.fromJson(e)).toList();
      });
    } catch (e) {
      debugPrint("Error loading JSON: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    productslist();
    _currentIndex = widget.selectedIndex;

    _pages = [
      HomeScreen(userDetails: widget.userDetails,selectedCategory: widget.selectedCategory,),
      category(userDetails: widget.userDetails,),
      Listorder_buyer(
        cartItems: widget.orderData?['cartItems'] ?? [],
        address: widget.orderData?['address'] ?? '',
        total: widget.orderData?['total'] ?? 0.0,
        status: widget.orderData?['status'] ?? '',
        orderNumber: widget.orderData?['orderNumber'] ?? '',
        userDetails: widget.userDetails,
      ),
      Shpping_card(userDetails: widget.userDetails),
      Myaccount_buyer(userDetails: widget.userDetails),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: const Color(0xFFA8D5BA),
        selectedItemColor: const Color(0xFF657C55),
        unselectedItemColor: Colors.black54,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'หน้าหลัก',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'หมวดหมู่',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'รายการสั่งซื้อ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'ตระกร้า',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'บัญชีผู้ใช้',
          ),
        ],
      ),
    );
  }
}
