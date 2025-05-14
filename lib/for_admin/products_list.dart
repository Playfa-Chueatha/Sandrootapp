import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sandy_roots/for_admin/add_product.dart';
import 'package:sandy_roots/for_admin/dialog_order.dart';
import 'package:sandy_roots/data.dart';

class ProductsList extends StatefulWidget {
  const ProductsList({super.key});

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/Products.json';  // ระบุตำแหน่งไฟล์ที่เก็บข้อมูล
  }

  Future<void> _loadProducts() async {
  try {
    final filePath = await _getFilePath();
    final file = File(filePath);

    // ตรวจสอบว่าไฟล์มีข้อมูลหรือไม่
    if (await file.exists()) {
      final jsonStr = await file.readAsString();
      if (jsonStr.isNotEmpty) {
        final List<Product> loadedProducts =
            (json.decode(jsonStr) as List).map((e) => Product.fromJson(e)).toList();
        setState(() {
          _products = loadedProducts;
        });
      }
    } else {
      // กรณีที่ไฟล์ไม่พบหรือว่างเปล่า
      setState(() {
        _products = [];
      });
    }
  } catch (e) {
    // หากมีข้อผิดพลาดในการโหลด
    print('Error loading products: $e');
  }
}




  Future<void> _saveProducts() async {
    try {
      final filePath = await _getFilePath();
      final file = File(filePath);

      final jsonStr = json.encode(_products.map((e) => e.toJson()).toList());
      await file.writeAsString(jsonStr);
    } catch (e) {
      // print('Error saving products: $e');
    }
  }

  void _addProduct(Product newProduct) {
    setState(() {
      _products.add(newProduct);
    });
    _saveProducts();  // บันทึกข้อมูลใหม่ลงไฟล์ JSON
  }


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
              if (result != null && result is Product) {
                _addProduct(result);
              }
            },
            icon: const Icon(Icons.add),
            label: const Text('เพิ่มสินค้า'),
          )
        ],
      ),
      body: _products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
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
                                setState(() {
                                  _products[index] = updatedProduct;
                                });
                              },
                              onDelete: (id) {
                                setState(() {
                                  _products.removeAt(index);
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
