import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sandy_roots/Data/data_Product.dart';
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
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/Products.json');


  if (await file.exists()) {
    final content = await file.readAsString();
    final data = json.decode(content) as List;
    setState(() {
      _products = data.map((e) => Product.fromJson(e)).toList();
      _filteredProducts = _products;
    });
  } else {
    // กรณีที่ยังไม่มีไฟล์ ให้ copy จาก assets มา
    final raw = await rootBundle.loadString('assets/data/Products.json');
    await file.writeAsString(raw);
    final data = json.decode(raw) as List;
    setState(() {
      _products = data.map((e) => Product.fromJson(e)).toList();
      _filteredProducts = _products;
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
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F3),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //------------------- banner ---------------------
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
                        onChanged: (_) => _onSearch(),
                      ),
                    ),
                    const SizedBox(width: 0),
                    ElevatedButton(
                    onPressed: () {
                      if (_searchController.text.isNotEmpty ) {
                        // ล้างข้อมูล
                        setState(() {
                          _searchController.clear();
              
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
                    child: (_searchController.text.isNotEmpty )
                        ? const Icon(Icons.clear, color: Colors.white) // ล้าง
                        : const Icon(Icons.search, color: Colors.white), // ค้นหา
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
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
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
                          borderRadius: BorderRadius.circular(16),
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
                                                  builder: (context) => Detailproduct_admin(
                                                    id: product.id,
                                                    name: product.name,
                                                    price: product.price,
                                                    description: product.description,
                                                    imageUrl: product.imageUrl,
                                                    category: product.category,
                                                    
                                                  ),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0xFFf0ede4),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                            ),
                                            child: Text('ดูรายละเอียด', 
                                            style: GoogleFonts.notoSansThai(
                                              fontSize: 12, 
                                              color: Colors.black,
                                            ))
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
        )
      ));
  }
}
