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