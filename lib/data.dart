import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class DataUser {
  List<Map<String, dynamic>> users = [];

  Future<void> loadUsers() async {
    final file = await _getUserFile();
    if (await file.exists()) {
      String content = await file.readAsString();
      users = List<Map<String, dynamic>>.from(json.decode(content));
    } else {
      String assetContent = await rootBundle.loadString('assets/data/users.json');
      await file.writeAsString(assetContent);
      users = List<Map<String, dynamic>>.from(json.decode(assetContent));
    }
  }

  Future<void> saveUsers() async {
    final file = await _getUserFile();
    await file.writeAsString(json.encode(users));
  }

  Future<File> _getUserFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/users.json');
  }

  bool login(String usernameOrEmail, String password) {
    return users.any((user) =>
      (user['email'] == usernameOrEmail || user['username'] == usernameOrEmail)
      && user['password'] == password);
  }

  bool register(String email, String username, String password) {
    bool exists = users.any((u) =>
      u['email'] == email || u['username'] == username);
    if (exists) return false;

    users.add({
      'email': email,
      'username': username,
      'password': password,
    });
    return true;
  }

  // ✅ เพิ่มฟังก์ชันนี้เพื่อดึงข้อมูลผู้ใช้ที่ล็อกอิน
  UserProfile? getUserProfile(String usernameOrEmail, String password) {
    try {
      final user = users.firstWhere((user) =>
        (user['email'] == usernameOrEmail || user['username'] == usernameOrEmail) &&
        user['password'] == password);

      return UserProfile(
        email: user['email'],
        username: user['username'],
      );
    } catch (e) {
      return null;
    }
  }
}


//user
class UserProfile {
  final String email;
  late final String username;

  UserProfile({required this.email, required this.username});
}



//Products
class Product {
  final int id;
  final String name;
  final int price;
  final String description;
  final String imageUrl;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        name: json['name'],
        price: json['price'],
        description: json['description'],
        imageUrl: json['imageUrl'],
        category: json['category'],
      );
}


//shopping Cart
class Cart {
  static final List<Map<String, dynamic>> _items = [];

  static List<Map<String, dynamic>> getItems() {
    return _items;
  }

  static double getTotalPrice() {
    double total = 0;
    for (var item in _items) {
      total += item['price'] * item['quantity'];
    }
    return total;
  }

  static void addItem(Map<String, dynamic> newItem) {
    final index = _items.indexWhere((item) => item['id'] == newItem['id']);
    if (index >= 0) {
      _items[index]['quantity'] += 1;
    } else {
      newItem['quantity'] = 1;
      _items.add(newItem);
    }
  }

  static void increaseQuantity(String id) {
    final index = _items.indexWhere((item) => item['id'] == id);
    if (index >= 0) {
      _items[index]['quantity'] += 1;
    }
  }

  static void decreaseQuantity(String id) {
    final index = _items.indexWhere((item) => item['id'] == id);
    if (index >= 0) {
      if (_items[index]['quantity'] > 1) {
        _items[index]['quantity'] -= 1;
      } else {
        _items.removeAt(index);
      }
    }
  }
  static void clear() {
    _items.clear();
  }
}
