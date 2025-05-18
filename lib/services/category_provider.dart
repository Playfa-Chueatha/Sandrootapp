import 'package:shared_preferences/shared_preferences.dart';

class CategoryManager {
  CategoryManager._privateConstructor();
  static final CategoryManager instance = CategoryManager._privateConstructor();

  List<String> categories = [];

  static const _key = 'categories_key';

  
  final List<String> _defaultCategories = [
    'ไม้ประดับ',
    'สายขน',
    'ไม้เลื้อย/หางยาว',
    'ไม้จิ๋ว/ไม้ถาด',
  ];

  Future<void> loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCategories = prefs.getStringList(_key);

    
    if (savedCategories == null || savedCategories.isEmpty) {
      categories = List.from(_defaultCategories);
      await _saveCategories(); 
    } else {
      categories = savedCategories;
    }
  }

  Future<void> addCategory(String category) async {
    categories.add(category);
    await _saveCategories();
  }

  Future<void> _saveCategories() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, categories);
  }

  
  Future<void> resetToDefault() async {
    categories = List.from(_defaultCategories);
    await _saveCategories();
  }
}
