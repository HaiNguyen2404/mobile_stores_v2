import 'package:mobile_store/features/cart/data/datasources/order_data_source.dart';
import 'package:mobile_store/features/cart/data/models/order_model.dart';
import 'package:mobile_store/features/cart/domain/entities/cart.dart';
import 'package:mobile_store/features/cart/domain/repositories/cart_repo.dart';
import 'package:mobile_store/features/home/data/models/product_model.dart';
import 'package:mobile_store/features/home/domain/entities/product.dart';

import '../../domain/entities/order.dart';

class CartRepoImpl implements CartRepo {
  final OrderDataSource orderDataSource;

  CartRepoImpl(this.orderDataSource);

  @override
  Cart getCart() {
    List<Order> orders = orderDataSource
        .getOrders()
        .map<Order>((order) => order.toEntity())
        .toList();

    return Cart(orderList: orders);
  }

  @override
  void addOrder(Product product) {
    OrderModel orderToAdd = ProductModel.fromEntity(product).toOrder();

    orderDataSource.addOrder(orderToAdd);
  }

  @override
  void deleteOrder(Order order) {
    OrderModel orderToDelete = OrderModel.fromEntity(order);

    orderDataSource.deleteOrder(orderToDelete);
  }

  @override
  void clearCart() {
    orderDataSource.clearAllOrders();
  }

  @override
  Future<bool> checkout() async {
    return await orderDataSource.checkout();
  }
}
