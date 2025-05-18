import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  Future<void> _addCategory() async {
    String newCategory = '';
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('เพิ่มหมวดหมู่'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(hintText: 'ชื่อหมวดหมู่'),
          onChanged: (value) {
            newCategory = value.trim();
          },
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ยกเลิก',style: TextStyle(color: Colors.red))),
          TextButton(
            onPressed: () async {
              if (newCategory.isNotEmpty) {
                await CategoryManager.instance.addCategory(newCategory);
                await loadCategories();
                Navigator.pop(context);
              }
            },
            child: const Text('บันทึก',style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  Future<void> _editCategory(int index) async {
    String editedCategory = categories[index];
    TextEditingController controller = TextEditingController(text: editedCategory);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('แก้ไขหมวดหมู่'),
        content: TextField(
          autofocus: true,
          controller: controller,
          decoration: const InputDecoration(hintText: 'ชื่อหมวดหมู่'),
          onChanged: (value) {
            editedCategory = value.trim();
          },
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ยกเลิก',style: TextStyle(color: Colors.red))),
          TextButton(
            onPressed: () async {
              if (editedCategory.isNotEmpty) {
                categories[index] = editedCategory;
                await CategoryManager.instance.saveCategories();
                setState(() {});
                Navigator.pop(context);
              }
            },
            child: const Text('บันทึก',style: TextStyle(color: Colors.green),),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteCategory(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('ลบหมวดหมู่'),
        content: Text('คุณต้องการลบหมวดหมู่ "${categories[index]}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('ยกเลิก',style: TextStyle(color: Colors.black),)),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('ลบ',style: TextStyle(color: Colors.red),)),
        ],
      ),
    );

    if (confirm == true) {
      categories.removeAt(index);
      await CategoryManager.instance.saveCategories();
      setState(() {});
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFFf6f3ec),
    appBar: AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded,
            color: Color.fromARGB(255, 0, 0, 0)),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text('Manage Categories'),
      backgroundColor: const Color(0xFFf6f3ec),
      // ลบ actions: ออก
    ),
    body: categories.isEmpty
        ? const Center(child: Text('คุณยังไม่ได้เพิ่มหมวดหมู่'))
        : ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: Offset(0, 3),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(cat),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: FaIcon(FontAwesomeIcons.edit, color: Colors.black),
                        onPressed: () => _editCategory(index),
                      ),
                      IconButton(
                        icon: FaIcon(FontAwesomeIcons.trash, color: Colors.red),
                        onPressed: () => _deleteCategory(index),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
    floatingActionButton: Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Material(
          elevation: 8, // ทำให้ปุ่มนูนและมีเงา
          borderRadius: BorderRadius.circular(30),
          child: ElevatedButton.icon(
            onPressed: _addCategory,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF568203).withOpacity(0.6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              elevation: 8, 
              shadowColor: Colors.black54,
            ),
            icon: FaIcon(FontAwesomeIcons.add, color: Colors.white),
            label: const Text(
              'Add Category',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
  );
}}
