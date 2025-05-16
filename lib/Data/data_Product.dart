class Product {
  final int id;
  final String name;
  final int price;
  final String description;
  final String category;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.category,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'] is int ? json['price'] : int.tryParse(json['price'].toString()) ?? 0,
      description: json['description'],
      category: json['category'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'category': category,
      'imageUrl': imageUrl,
    };
  }
}