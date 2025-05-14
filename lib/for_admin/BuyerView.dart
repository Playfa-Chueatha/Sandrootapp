import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sandy_roots/data.dart';
import 'package:sandy_roots/for_admin/detailproduct_admin.dart';

class BuyerView extends StatefulWidget {
  const BuyerView({super.key});

  @override
  State<BuyerView> createState() => _BuyerViewState();
}

class _BuyerViewState extends State<BuyerView> {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  final TextEditingController _searchController = TextEditingController();
  final List<String> _searchHistory = [];

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final String response = await rootBundle.loadString('assets/data/Products.json');
    final data = await json.decode(response) as List;
    setState(() {
      _products = data.map((e) => Product.fromJson(e)).toList();
      _filteredProducts = _products;
    });
  }

  void _onSearch() {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _filteredProducts = _products;
      });
      return;
    }

    // เก็บประวัติการค้นหา
    if (!_searchHistory.contains(query)) {
      setState(() {
        _searchHistory.insert(0, query);
      });
    }

    setState(() {
      _filteredProducts = _products.where((product) {
        return product.name.toLowerCase().contains(query) ||
            product.description.toLowerCase().contains(query);
      }).toList();
    });
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
        title: const Text("Home"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            //------------------- banner ---------------------
            Container(
              width: double.infinity,
              height: screenHeight * 0.2,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/banner.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.all(16),
              child: const Text.rich(
                TextSpan(
                  text: 'Let Your Space\n',
                  style: TextStyle(fontSize: 22, color: Colors.black),
                  children: [
                    TextSpan(
                      text: 'Bloom.',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

            //------------- Search Box + Button ----------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'ค้นหากระบองเพชรที่คุณชื่นชอบ',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _onSearch,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA8D5BA),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('ค้นหา', style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ),

            //----------------- Search Suggestions ------------------
            if (_searchController.text.isNotEmpty && _searchHistory.isNotEmpty)
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Wrap(
                  spacing: 8,
                  children: _searchHistory
                      .where((item) => item.contains(_searchController.text.toLowerCase()))
                      .map((item) => ActionChip(
                            label: Text(item),
                            backgroundColor: Colors.grey.shade200,
                            onPressed: () {
                              _searchController.text = item;
                              _onSearch();
                            },
                          ))
                      .toList(),
                ),
              ),

            //---------------- Product List --------------------
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: GridView.builder(
                  itemCount: _filteredProducts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) {
                    final product = _filteredProducts[index];
                    return Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              product.imageUrl,
                              height: screenHeight * 0.15,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.001),
                          Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            product.description,
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Text('${product.price} ฿', style: const TextStyle(color: Colors.green, fontSize: 14)),
                          SizedBox(height: screenHeight * 0.01),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => Detailproduct_admin(
                                    id: product.id,
                                    name: product.name,
                                    price: product.price,
                                    description: product.description,
                                    imageUrl: product.imageUrl,
                                    category: product.category,
                                  ))
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFA8D5BA),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text('ดูรายละเอียด', style: TextStyle(fontSize: 12, color: Colors.black)),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
