import 'package:flutter/material.dart';
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
  final allCategories = CategoryManager.instance.categories;

  List<String> filteredCategories = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredCategories = List.from(allCategories);
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
        backgroundColor: const Color(0xFFA8D5BA),
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () => Navigator.pop(context),
        // ),
        title: const Text("Category"),
        
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: searchController,
              onChanged: filterCategories,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "ค้นหาหมวดหมู่",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              itemCount: filteredCategories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (context, index) {
                final category = filteredCategories[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: InkWell(
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
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: AssetImage('assets/images/default_sandyroot.png'),
                            backgroundColor: Colors.grey[200],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            category,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
