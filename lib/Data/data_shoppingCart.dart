import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Cart {
  // ดึงตะกร้าของ user ที่ระบุ (async เพราะต้องอ่านจาก SharedPreferences)
  static Future<List<Map<String, dynamic>>> getItems(String userEmail) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('cart_$userEmail');
    if (jsonString == null) return [];
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return List<Map<String, dynamic>>.from(jsonList);
  }

  // บันทึกตะกร้าของ user ลง SharedPreferences
  static Future<void> saveItems(String userEmail, List<Map<String, dynamic>> items) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(items);
    await prefs.setString('cart_$userEmail', jsonString);
  }

  // คำนวณราคาทั้งหมด
  static Future<double> getTotalPrice(String userEmail) async {
    final items = await getItems(userEmail);
    double total = 0;
    for (var item in items) {
      total += item['price'] * item['quantity'];
    }
    return total;
  }

  // เพิ่มสินค้าในตะกร้า
  static Future<void> addItem(String userEmail, Map<String, dynamic> newItem) async {
    final items = await getItems(userEmail);
    final index = items.indexWhere((item) => item['id'] == newItem['id']);
    if (index >= 0) {
      items[index]['quantity'] += 1;
    } else {
      newItem['quantity'] = 1;
      items.add(newItem);
    }
    await saveItems(userEmail, items);
  }

  // เพิ่มจำนวนสินค้า
  static Future<void> increaseQuantity(String userEmail, int id) async {
    final items = await getItems(userEmail);
    final index = items.indexWhere((item) => item['id'] == id);
    if (index >= 0) {
      items[index]['quantity'] += 1;
      await saveItems(userEmail, items);
    }
  }

  // ลดจำนวนสินค้า (ถ้าจำนวนเป็น 0 ให้ลบออก)
  static Future<void> decreaseQuantity(String userEmail, int id) async {
    final items = await getItems(userEmail);
    final index = items.indexWhere((item) => item['id'] == id);
    if (index >= 0) {
      if (items[index]['quantity'] > 1) {
        items[index]['quantity'] -= 1;
      } else {
        items.removeAt(index);
      }
      await saveItems(userEmail, items);
    }
  }

  // อัปเดตจำนวนสินค้า
  static Future<void> updateQuantity(String userEmail, int id, int quantity) async {
    if (quantity <= 0) return; // ป้องกันจำนวนติดลบหรือติดศูนย์
    final items = await getItems(userEmail);
    final index = items.indexWhere((item) => item['id'] == id);
    if (index >= 0) {
      items[index]['quantity'] = quantity;
      await saveItems(userEmail, items);
    }
  }

  // ลบสินค้าออกจากตะกร้า
  static Future<void> removeItem(String userEmail, int id) async {
    final items = await getItems(userEmail);
    items.removeWhere((item) => item['id'] == id);
    await saveItems(userEmail, items);
  }

  // ล้างตะกร้าทั้งหมด
  static Future<void> clear(String userEmail) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cart_$userEmail');
  }
}
