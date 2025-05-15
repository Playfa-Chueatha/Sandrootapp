import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    return '${directory.path}/Products.json';
  }

  Future<void> _loadProducts() async {
    setState(() {
    });
    
    try {
      final filePath = await _getFilePath();
      final file = File(filePath);

      if (await file.exists()) {
        // โหลดจาก storage
        final jsonStr = await file.readAsString();
        if (jsonStr.isNotEmpty) {
          final List<Product> loadedProducts =
              (json.decode(jsonStr) as List).map((e) => Product.fromJson(e)).toList();
          setState(() {
            _products = loadedProducts;
          });
        }
      } else {
        // โหลดจาก assets เป็นข้อมูลเริ่มต้น
        final jsonStr = await rootBundle.loadString('assets/data/Products.json');
        final List<Product> loadedProducts =
            (json.decode(jsonStr) as List).map((e) => Product.fromJson(e)).toList();

        // บันทึกไฟล์ใน storage เพื่อใช้ต่อไป
        await file.writeAsString(jsonStr);

        setState(() {
          _products = loadedProducts;
        });
      }
    } catch (e) {
      // print('Error loading products: $e');
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

  void _addProductFromMap(Map<String, dynamic> map) {
    final newProduct = Product(
      id: DateTime.now().millisecondsSinceEpoch,
      name: map['name'],
      price: int.tryParse(map['price'].toString()) ?? 0,
      description: map['description'],
      category: map['category'],
      imageUrl: map['image'],
    );
    setState(() {
      _products.add(newProduct);
    });
    _saveProducts();
  }

  void _updateProduct(int index, Product updatedProduct) {
    setState(() {
      _products[index] = updatedProduct;
    });
    _saveProducts();
  }

  void _deleteProduct(int index) {
    setState(() {
      _products.removeAt(index);
    });
    _saveProducts();
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
              if (result != null && result is Map<String, dynamic>) {
                _addProductFromMap(result);
              }
            },
            icon: const Icon(Icons.add),
            label: const Text('เพิ่มสินค้า'),
          )
        ],
      ),
      body: _products.isEmpty
          ? Center(
              child: Text(
                'เพิ่มสินค้าของคุณ',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
            )
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
                          backgroundImage: product.imageUrl.startsWith('assets/')
                              ? AssetImage(product.imageUrl) as ImageProvider
                              : FileImage(File(product.imageUrl)),
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
                                _updateProduct(index, updatedProduct);
                              },
                              onDelete: (id) {
                                _deleteProduct(index);
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
