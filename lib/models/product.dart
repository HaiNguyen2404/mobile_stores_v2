class Product {
  int id;
  String name;
  int price;
  int quantity;
  String description;
  String manufacturer;
  String category;
  String condition;
  String image;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.description,
    required this.manufacturer,
    required this.category,
    required this.condition,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      price: json['price'] as int,
      quantity: json['quantity'] as int,
      description: json['description'] as String,
      manufacturer: json['manufacturer'] as String,
      category: json['category'] as String,
      condition: json['condition'] as String,
      image: json['image'] as String,
    );
  }
}
