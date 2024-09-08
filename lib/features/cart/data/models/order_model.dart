import 'package:mobile_store/features/cart/domain/entities/order.dart';

class OrderModel {
  int id;
  String name;
  int price;
  int quantity;

  OrderModel({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      "productId": id,
      "quantity": quantity,
      "unitPrice": price,
    };
  }

  factory OrderModel.fromEntity(Order order) {
    return OrderModel(
      id: order.id,
      name: order.name,
      price: order.price,
      quantity: order.quantity,
    );
  }

  Order toEntity() {
    return Order(
      id: id,
      name: name,
      price: price,
      quantity: quantity,
    );
  }
}
