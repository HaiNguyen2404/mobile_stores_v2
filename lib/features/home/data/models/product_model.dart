import 'package:mobile_store/features/cart/data/models/order_model.dart';
import 'package:mobile_store/features/home/domain/entities/product.dart';

class ProductModel {
  int id;
  String name;
  int price;
  int quantity;
  String description;
  String manufacturer;
  String category;
  String condition;
  String image;

  ProductModel({
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

  factory ProductModel.fromEntity(Product entity) {
    return ProductModel(
      id: entity.id,
      name: entity.name,
      price: entity.price,
      quantity: entity.quantity,
      description: entity.description,
      manufacturer: entity.manufacturer,
      category: entity.category,
      condition: entity.condition,
      image: entity.image,
    );
  }

  Product toEntity() {
    return Product(
      id: id,
      name: name,
      price: price,
      quantity: quantity,
      description: description,
      manufacturer: manufacturer,
      category: category,
      condition: condition,
      image: image,
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      quantity: json['quantity'],
      description: json['description'],
      manufacturer: json['manufacturer'],
      category: json['category'],
      condition: json['condition'],
      image: json['image'],
    );
  }

  OrderModel toOrder() {
    return OrderModel(
      id: id,
      name: name,
      price: price,
      quantity: 1,
    );
  }
}
