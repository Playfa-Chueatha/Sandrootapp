import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sandy_roots/Data/data_Product.dart';
import 'package:sandy_roots/for_admin/BuyerView.dart';
import 'package:sandy_roots/for_admin/Listorder_admin.dart';
import 'package:sandy_roots/for_admin/Myaccount.dart';
import 'package:sandy_roots/for_admin/products_list.dart';


class AppbarAdmin extends StatefulWidget {
  const AppbarAdmin({super.key});

  @override
  State<AppbarAdmin> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<AppbarAdmin> {
  List<Product> products = [];
  int _currentIndex = 0;

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
    Widget currentPage;
  switch (_currentIndex) {
    case 0:
      currentPage = ProductsList(
        key: UniqueKey(),
      );
      break;
    case 1:
      currentPage = Listorder();
      break;
    case 2:
      currentPage = BuyerView();
      break;
    case 3:
      currentPage = Myaccount();
      break;
    default:
      currentPage = ProductsList();
  }
    return Scaffold(
      body: currentPage,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: _currentIndex,
        selectedItemColor:  Color(0xFF8B6F4D),
        unselectedItemColor:  Color.fromARGB(255, 0, 0, 0),
        onTap: (index) => setState(() => _currentIndex = index),
        items:  [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.store),
            label: 'จัดการสินค้า',backgroundColor: Color(0xFFf6f3ec)
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.clipboardList),
            label: 'รายการสั่งซื้อ',backgroundColor: Color(0xFFf6f3ec)
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.eye),
            label: 'มุมมองผู้ซื้อ',backgroundColor: Color(0xFFf6f3ec)
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.user),
            label: 'บัญชีผู้ใช้',backgroundColor: Color(0xFFf6f3ec)
          ),
        ],
      ),
    );
  }
}


