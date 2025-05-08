import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sandy_roots/screens/dialog_order.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<Product> products = [];

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
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F3),
      appBar: AppBar(title: const Text("My Products")),
      body: products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
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
                            builder: (context) => dialog_order(
                              id: product.id,
                              name: product.name,
                              price: product.price,
                              description: product.description,
                              imageUrl: product.imageUrl,
                              onSave: (updatedProduct) {
                                setState(() {
                                  final idx = products.indexWhere((p) => p.id == updatedProduct.id);
                                  if (idx != -1) {
                                    products[idx] = updatedProduct;
                                  }
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class Product {
  final int id;
  final String name;
  final int price;
  final String description;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        name: json['name'],
        price: json['price'],
        description: json['description'],
        imageUrl: json['imageUrl'],
      );
}
