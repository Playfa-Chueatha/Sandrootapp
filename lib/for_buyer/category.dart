import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandy_roots/Data/data_user.dart';
import 'package:sandy_roots/screens/Appbar_buyer.dart';
import 'package:sandy_roots/services/category_provider.dart';

class category extends StatefulWidget {
  final UserProfile userDetails;
  const category({super.key, required this.userDetails});

  @override
  State<category> createState() => _categoryState();
}

class _categoryState extends State<category> {
  List<String> allCategories = [];
  List<String> filteredCategories = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> loadCategories() async {
    await CategoryManager.instance.loadCategories(); // โหลดจาก local storage หรือไฟล์
    setState(() {
      allCategories = List.from(CategoryManager.instance.categories);
      filteredCategories = List.from(allCategories);
    });
  }

  void filterCategories(String query) {
    final lowerQuery = query.toLowerCase();
    setState(() {
      filteredCategories = allCategories
          .where((String category) => category.toLowerCase().contains(lowerQuery))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F3),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFf6f3ec),
        title: Text(     
            'Categoly',
            style: GoogleFonts.notoSansThai(
              fontSize: 30
            ),
          ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26, 
                    blurRadius: 6, 
                    offset: Offset(2, 4), 
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                onChanged: filterCategories,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "ค้นหาหมวดหมู่",
                  hintStyle: GoogleFonts.notoSansThai(
                    fontSize: 16
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none, 
                  ),
                  filled: true,
                  fillColor: Colors.white, 
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredCategories.isEmpty
                ? Center(
                  child: Text(
                    'ไม่พบหมวดหมู่',
                    style: GoogleFonts.notoSansThai(
                          color: Colors.black
                    )
                  )
                )
                : ListView.builder(
              itemCount: filteredCategories.length,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemBuilder: (context, index) {
                final category = filteredCategories[index];
                return Card(
                  color: const Color(0xFFD8CAB8), 
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AppbarBuyer(
                            selectedIndex: 0,
                            userDetails: widget.userDetails,
                            selectedCategory: category,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      child: Text(
                        category,
                        style: GoogleFonts.notoSansThai(
                          fontSize: 16,         
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          )
        ],
      ),
    );
  }
}
