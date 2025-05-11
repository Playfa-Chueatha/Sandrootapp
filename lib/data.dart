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
  static List<Map<String, dynamic>> items = [];

  static void addItem(Map<String, dynamic> newItem) {
    int index = items.indexWhere((item) => item['id'] == newItem['id']);
    if (index >= 0) {
      items[index]['quantity'] += 1;
    } else {
      items.add({
        ...newItem,
        'quantity': 1,
      });
    }
  }

  static void increaseQuantity(int id) {
    int index = items.indexWhere((item) => item['id'] == id);
    if (index >= 0) {
      items[index]['quantity'] += 1;
    }
  }

  static void decreaseQuantity(int id) {
    int index = items.indexWhere((item) => item['id'] == id);
    if (index >= 0) {
      if (items[index]['quantity'] > 1) {
        items[index]['quantity'] -= 1;
      } else {
        items.removeAt(index);
      }
    }
  }

  static List<Map<String, dynamic>> getItems() {
    return items;
  }

  static double getTotalPrice() {
    return items.fold(0, (sum, item) => sum + item['price'] * item['quantity']);
  }
}


