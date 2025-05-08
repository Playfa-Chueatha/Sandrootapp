import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sandy_roots/Order_for_admin/add_product.dart';
import 'package:sandy_roots/Order_for_admin/dialog_order.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<Product> products = [];
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ProductsPage(),
    const CartPage(),
    const BuyerView(),
    const ProfilePage(),
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
            label: 'สินค้า',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'รายการสั่งซื้อ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.visibility),
            label: 'มุมมองผู้ซื้อ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'โปรไฟล์',
          ),
        ],
      ),
    );
  }
}

/// หน้าสินค้า
class ProductsPage extends StatelessWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFA8D5BA),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("My Products"),
        actions: [
          OutlinedButton.icon(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => const AddProductPage(),
                ),
              );
              if (result != null && result is Map<String, dynamic>) {
                // handle new product
              }
            },
            icon: const Icon(Icons.add),
            label: const Text('เพิ่มสินค้า'),
          )
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: rootBundle.loadString('assets/data/Order.json').then(
            (jsonStr) => (json.decode(jsonStr) as List)
                .map((e) => Product.fromJson(e))
                .toList()),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final products = snapshot.data!;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Container(
                height: screenHeight * 0.12,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(product.imageUrl),
                      ),
                    ),
                    Expanded(child: Text(product.name)),
                    Text('${product.price} ฿'),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (c) => dialog_order(
                            id: product.id,
                            name: product.name,
                            price: product.price,
                            description: product.description,
                            imageUrl: product.imageUrl,
                            category: product.category,
                            onSave: (updatedProduct) {
                              // update product
                            },
                            onDelete: (id) {
                              // delete product
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// หน้าตะกร้า (ตัวอย่าง)
class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Cart Page'));
  }
}

/// มุมมองผู้ซื้อ (ใหม่)
class BuyerView extends StatelessWidget {
  const BuyerView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Buyer View Page'));
  }
}

/// หน้าโปรไฟล์ (ตัวอย่าง)
class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Profile Page'));
  }
}

class Product {
  final int id;
  final String name;
  final int price;
  final String description;
  final String imageUrl;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        name: json['name'],
        price: json['price'],
        description: json['description'],
        imageUrl: json['imageUrl'],
        category: json['category'],
      );
}