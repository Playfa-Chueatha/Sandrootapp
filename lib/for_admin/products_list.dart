import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sandy_roots/for_admin/add_product.dart';
import 'package:sandy_roots/for_admin/dialog_order.dart';
import 'package:sandy_roots/data.dart';

class Products_list extends StatelessWidget {
  const Products_list({super.key});

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
                              
                            },
                            onDelete: (id) {
                              
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