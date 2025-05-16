import 'package:flutter/material.dart';
import 'package:sandy_roots/services/category_provider.dart';

class CategoryListPage extends StatefulWidget {
  const CategoryListPage({super.key});

  @override
  State<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  List<String> categories = [];

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> loadCategories() async {
    await CategoryManager.instance.loadCategories();
    setState(() {
      categories = CategoryManager.instance.categories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('หมวดหมู่ทั้งหมด'),
        backgroundColor: const Color(0xFFA8D5BA),
      ),
      body: categories.isEmpty
          ? const Center(child: Text('ไม่มีหมวดหมู่ในระบบ'))
          : ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                return ListTile(
                  title: Text(cat),
                );
              },
            ),
    );
  }
}
