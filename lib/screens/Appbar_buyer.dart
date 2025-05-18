import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sandy_roots/Data/data_Product.dart';
import 'package:sandy_roots/Data/data_user.dart';
import 'package:sandy_roots/for_buyer/Home.dart';
import 'package:sandy_roots/for_buyer/Listorder_buyer.dart';
import 'package:sandy_roots/for_buyer/Myaccount.dart';
import 'package:sandy_roots/for_buyer/Shpping_card.dart';
import 'package:sandy_roots/for_buyer/category.dart';

class AppbarBuyer extends StatefulWidget {
  final UserProfile userDetails;
  final int selectedIndex;
  final Map<String, dynamic>? orderData;
  final String? selectedCategory;

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
  String? _selectedCategory;

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
    _selectedCategory = widget.selectedCategory;
  }

  @override
  void didUpdateWidget(covariant AppbarBuyer oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.selectedCategory != oldWidget.selectedCategory) {
      setState(() {
        _selectedCategory = widget.selectedCategory;
      });
    }
  }

  @override
Widget build(BuildContext context) {
  Widget currentPage;
  switch (_currentIndex) {
    case 0:
      currentPage = HomeScreen(
        key: UniqueKey(),
        userDetails: widget.userDetails,
        selectedCategory: _selectedCategory,
        onClearCategory: () {
          setState(() {
            _selectedCategory = null;
          });
        },
      );
      break;
    case 1:
      currentPage = category(userDetails: widget.userDetails);
      break;
    case 2:
      currentPage = Listorder_buyer(
        orderNumber: widget.orderData?['orderNumber'] ?? '',
        cartItems: List<Map<String, dynamic>>.from(widget.orderData?['cartItems'] ?? []),
        total: widget.orderData?['total'] ?? 0.0,
        address: widget.orderData?['address'] ?? '',
        status: widget.orderData?['status'] ?? '',
        userDetails: widget.userDetails,
      );
      break;
    case 3:
      currentPage = Shpping_card(userDetails: widget.userDetails);
      break;
    case 4:
      currentPage = Myaccount_buyer(userDetails: widget.userDetails);
      break;
    default:
      currentPage = HomeScreen(userDetails: widget.userDetails);
  }

  return Scaffold(
    body: currentPage,
    bottomNavigationBar: BottomNavigationBar(
      type: BottomNavigationBarType.shifting,
      currentIndex: _currentIndex, 
      selectedItemColor: const Color(0xFF8B6F4D),
      unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
      onTap: (index) {
        setState(() {
          _currentIndex = index;

          if (index == 0) {
            _selectedCategory = null; 
          }
        });
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.home), label: 'หน้าหลัก',backgroundColor: Color(0xFFf6f3ec)),
        BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.list), label: 'หมวดหมู่',backgroundColor: Color(0xFFf6f3ec)),
        BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.clipboardList), label: 'รายการสั่งซื้อ',backgroundColor: Color(0xFFf6f3ec)),
        BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.shoppingCart), label: 'ตระกร้า',backgroundColor: Color(0xFFf6f3ec)),
        BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.user), label: 'บัญชีผู้ใช้',backgroundColor: Color(0xFFf6f3ec)),
      ],
    ),
  );
}
}
