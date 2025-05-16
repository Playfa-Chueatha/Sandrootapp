import 'package:shared_preferences/shared_preferences.dart';

class CategoryManager {
  CategoryManager._privateConstructor();
  static final CategoryManager instance = CategoryManager._privateConstructor();

  List<String> categories = [];

  static const _key = 'categories_key';

  Future<void> loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    categories = prefs.getStringList(_key) ?? [];
  }

  Future<void> addCategory(String category) async {
    categories.add(category);
    await _saveCategories();
  }

  Future<void> _saveCategories() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, categories);
  }
}
