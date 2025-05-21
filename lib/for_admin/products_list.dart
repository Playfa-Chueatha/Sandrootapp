import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sandy_roots/Data/data_Product.dart';
import 'package:sandy_roots/for_admin/add_product.dart';
import 'package:sandy_roots/for_admin/EditProducts.dart';

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
        final jsonStr = await file.readAsString();
        if (jsonStr.isNotEmpty) {
          final List<Product> loadedProducts =
              (json.decode(jsonStr) as List).map((e) => Product.fromJson(e)).toList();
          setState(() {
            _products = loadedProducts;
          });
        }
      } else {
       
        final jsonStr = await rootBundle.loadString('assets/data/Products.json');
        final List<Product> loadedProducts =
            (json.decode(jsonStr) as List).map((e) => Product.fromJson(e)).toList();

        
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
      backgroundColor: Color(0xFFf6f3ec),
      appBar: AppBar(
        backgroundColor: Color(0xFFf6f3ec),
        automaticallyImplyLeading: false,
        title: Text(
          'My Products',
          style: TextStyle(
              fontSize: 30
          )
        ),
        actions: [
          Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child:
          ElevatedButton.icon(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) =>  AddProductPage(),
                ),
              );
              if (result != null && result is Map<String, dynamic>) {
                _addProductFromMap(result);
              }
            },
            icon: Icon(Icons.add, color: Colors.white),
            label: Text('เพิ่มสินค้า', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor:  Color(0xFF8D6E63), 
              elevation: 6, 
              shadowColor: Colors.brown.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), 
              ),
              padding:  EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ))
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
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: const Offset(2, 3), 
                ),
              ],
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
                  icon:  FaIcon(FontAwesomeIcons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Editproducts(
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
                        )
                      )
                    );}        
                )
              ],
            ),
          );
        },
      )
    );
  }
}
