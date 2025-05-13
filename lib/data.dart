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
