import 'package:mobile_store/features/cart/data/models/order_model.dart';
import 'package:mobile_store/features/home/domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    required super.id,
    required super.name,
    required super.price,
    required super.quantity,
    required super.description,
    required super.manufacturer,
    required super.category,
    required super.condition,
    required super.image,
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
