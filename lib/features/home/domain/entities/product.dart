class Product {
  final int id;
  final String name;
  final int price;
  final int quantity;
  final String description;
  final String manufacturer;
  final String category;
  final String condition;
  final String? image;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.description,
    required this.manufacturer,
    required this.category,
    required this.condition,
    this.image,
  });
}
