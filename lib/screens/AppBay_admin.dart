import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sandy_roots/for_admin/BuyerView.dart';
import 'package:sandy_roots/for_admin/Listorder_admin.dart';
import 'package:sandy_roots/for_admin/products_list.dart';
import 'package:sandy_roots/data.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<ProductsScreen> {
  List<Product> products = [];
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ProductsList(),
    const Listorder(),
    const BuyerView(),
  ];

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor:  Color(0xFFA8D5BA),
        selectedItemColor: Color(0xFF657C55),
        unselectedItemColor: Colors.black54,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront),
            label: 'จัดการสินค้า',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'รายการสั่งซื้อ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.visibility),
            label: 'มุมมองผู้ซื้อ',
          ),
        ],
      ),
    );
  }
}


