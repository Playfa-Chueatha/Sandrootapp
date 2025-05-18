import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sandy_roots/Data/data_Product.dart';
import 'package:sandy_roots/Data/data_user.dart';
import 'package:sandy_roots/for_buyer/detailproduct.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  final UserProfile userDetails;
  final String? selectedCategory;
  final VoidCallback? onClearCategory;
  const HomeScreen({
    super.key, 
    required this.userDetails,
    this.selectedCategory, this.onClearCategory,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  final TextEditingController _searchController = TextEditingController();
  final List<String> _searchHistory = [];
  String? _activeCategory;
  


  @override
  void initState() {
    super.initState();
    _activeCategory = widget.selectedCategory;
    loadProducts();
  }

  Future<void> loadProducts() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/Products.json');

    if (await file.exists()) {
      final content = await file.readAsString();
      final data = json.decode(content) as List;
      final loadedProducts = data.map((e) => Product.fromJson(e)).toList();

      setState(() {
        _products = loadedProducts;
        _filteredProducts = _activeCategory != null
            ? loadedProducts.where((p) => p.category == _activeCategory).toList()
            : loadedProducts;
      });
    } else {
      final raw = await rootBundle.loadString('assets/data/Products.json');
      await file.writeAsString(raw);
      final data = json.decode(raw) as List;
      final loadedProducts = data.map((e) => Product.fromJson(e)).toList();

      setState(() {
        _products = loadedProducts;
        _filteredProducts = _activeCategory != null
            ? loadedProducts.where((p) => p.category == _activeCategory).toList()
            : loadedProducts;
      });
    }
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
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.selectedCategory != oldWidget.selectedCategory) {
      setState(() {
        _activeCategory = widget.selectedCategory;
        _filteredProducts = _activeCategory != null
            ? _products.where((p) => p.category == _activeCategory).toList()
            : _products;
      });
    }
  }


  

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFf6f3ec),
      body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ------------------- banner ---------------------
            Container(
              width: double.infinity,
              height: screenHeight * 0.3,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/banner2.png'),
                  fit: BoxFit.cover,
                ),
              ),           
            ),

            // ------------- Search Box + Button ----------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'ค้นหากระบองเพชรที่คุณชื่นชอบ',
                        hintStyle: GoogleFonts.notoSansThai(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                        
                        filled: true,
                        fillColor: const Color(0xFFEEEBE1),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (_) => _onSearch(),
                    ),
                  ),
                  const SizedBox(width: 0),
                  ElevatedButton(
                    onPressed: () {
                      if (_searchController.text.isNotEmpty || _activeCategory != null) {
                        // ล้างข้อมูล
                        setState(() {
                          _searchController.clear();
                          _activeCategory = null;
                          _filteredProducts = _products;
                        });
                      } else {
                        // ค้นหา
                        _onSearch();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFb7987c),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                    ),
                    child: (_searchController.text.isNotEmpty || _activeCategory != null)
                        ? const Icon(Icons.clear, color: Colors.white) // ล้าง
                        : const Icon(Icons.search, color: Colors.white), // ค้นหา
                  ),
                ],
              ),
            ),
            // ----------------- Search Suggestions ------------------
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

            // ---------------- Product List --------------------
            Padding(padding: EdgeInsets.all(10),
            child: GridView.builder(
                itemCount: _filteredProducts.length,
                shrinkWrap: true, 
                physics: const NeverScrollableScrollPhysics(), 
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  final product = _filteredProducts[index];
                  return Container(
                    
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)
                              ),
                            child: product.imageUrl.startsWith('assets/')
                                ? Image.asset(
                                    product.imageUrl,
                                    height: screenHeight * 0.15,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    File(product.imageUrl),
                                    height: screenHeight * 0.15,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        
                        Padding(
                          padding: EdgeInsets.fromLTRB(5, 5, 5, 1),
                          child: Text(
                            product.name, 
                            style: GoogleFonts.notoSansThai(fontSize: 16,color: Colors.black),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            )
                        ),
                        Padding(padding: EdgeInsets.fromLTRB(5, 1, 5, 2),
                          child: Text(
                              product.description,
                              style: GoogleFonts.notoSansThai(fontSize: 12, color: Colors.grey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(5, 2, 5, 5),
                          child: Text('${product.price} ฿', 
                            style: GoogleFonts.notoSansThai(
                              color: Color.fromARGB(255, 123, 131, 102), 
                              fontSize: 14
                            ))),
                        Spacer(),
                        Padding(padding: EdgeInsets.all(5),
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Detailproduct(
                                    id: product.id,
                                    name: product.name,
                                    price: product.price,
                                    description: product.description,
                                    imageUrl: product.imageUrl,
                                    category: product.category,
                                    userDetails: widget.userDetails,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFC3B091),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              elevation: 2,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  FontAwesomeIcons.eye,
                                  size: 18,
                                  color: Color(0xFF654321),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'ดูรายละเอียด',
                                  style: GoogleFonts.notoSansThai(
                                    fontSize: 14,
                                    color: Color(0xFF654321),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                      ],
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: screenHeight * 0.01) 
          ],
        ),
      ),
    ));

  }
}
