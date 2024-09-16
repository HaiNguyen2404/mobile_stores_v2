import 'package:mobile_store/features/cart/domain/entities/cart.dart';
import 'package:mobile_store/features/cart/domain/entities/order.dart';
import 'package:mobile_store/features/home/domain/entities/product.dart';

abstract class CartRepo {
  Cart getCart();
  void addOrder(Product product);
  void deleteOrder(Order order);
  void clearCart();
  Future<bool> checkout(String token);
}
