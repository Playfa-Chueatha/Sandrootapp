import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DataUser {
  List<UserProfile> users = [];
  final String _fileName = 'user_data.json';

  // สร้าง getter สำหรับ _localFile
  Future<File> get localFile async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  Future<void> loadUsers() async {
    final file = await localFile;

    if (!await file.exists()) {
      await file.writeAsString('[]'); 
    }

    final contents = await file.readAsString();

    final dynamic jsonData = json.decode(contents);

    if (jsonData is List) {
      users = jsonData
          .map((e) => UserProfile.fromJson(e as Map<String, dynamic>))
          .toList();
    } else if (jsonData is Map<String, dynamic>) {
      users = [UserProfile.fromJson(jsonData)];
    } else {
      throw Exception('รูปแบบ JSON ไม่รองรับ');
    }
  }


  Future<void> saveUsers() async {
    final file = await localFile; // ใช้ localFile แทน _localFile
    final jsonList = users.map((u) => u.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonList));
  }

  bool login(String idOrEmail, String password) {
    final input = idOrEmail.toLowerCase();
    return users.any((u) =>
      (u.username.toLowerCase() == input || u.email.toLowerCase() == input) &&
      u.password == password
    );
  }

  UserProfile? getUserProfile(String idOrEmail, String password) {
    try {
      final input = idOrEmail.toLowerCase();
      return users.firstWhere((u) =>
        (u.username.toLowerCase() == input || u.email.toLowerCase() == input) &&
        u.password == password
      );
    } catch (_) {
      return null;
    }
  }

  bool register(String email, String username, String password) {
    final inputEmail = email.toLowerCase();
    final inputUser = username.toLowerCase();
    final exists = users.any((u) =>
      u.email.toLowerCase() == inputEmail ||
      u.username.toLowerCase() == inputUser
    );
    if (exists) return false;

    users.add(UserProfile(
      email: email,
      username: username,
      password: password,
      profileImage: 'assets/images/default_sandyroot.png',
    ));
    return true;
  }
}



//user
class UserProfile {
  String email;
  String username;
  String password;
  String profileImage;

  UserProfile({
    required this.email,
    required this.username,
    required this.password,
    required this.profileImage,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      email: json['email'] as String? ?? '',
      username: json['username'] as String? ?? '',
      password: json['password'] as String? ?? '',
      profileImage: json['profileImage'] as String? ?? '',
    );
  }



  Map<String, dynamic> toJson() => {
    'email': email,
    'username': username,
    'password': password,
    'profileImage': profileImage,
  };
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
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
    };
  }
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

  static void increaseQuantity(int id) {
    final index = _items.indexWhere((item) => item['id'] == id);
    if (index >= 0) {
      _items[index]['quantity'] += 1;
    }
  }

  static void decreaseQuantity(int id) {
    final index = _items.indexWhere((item) => item['id'] == id);
    if (index >= 0) {
      if (_items[index]['quantity'] > 1) {
        _items[index]['quantity'] -= 1;
      } else {
        _items.removeAt(index);
      }
    }
  }

  // เพิ่มฟังก์ชัน updateQuantity
  static void updateQuantity(int id, int quantity) {
    final index = _items.indexWhere((item) => item['id'] == id);
    if (index >= 0 && quantity > 0) {
      _items[index]['quantity'] = quantity;
    }
  }

  static void removeItem(int id) {
    _items.removeWhere((item) => item['id'] == id);
  }

  static void clear() {
    _items.clear();
  }
}
