import 'dart:convert';

import 'package:mobile_store/features/cart/data/models/order_model.dart';
import 'package:mobile_store/features/home/data/datasource/api_service.dart';

abstract class OrderDataSource {
  List<OrderModel> getOrders();
  void deleteOrder(OrderModel order);
  void addOrder(OrderModel order);
  void clearAllOrders();
  Future<bool> checkout();
}

class OrderDataSourceImpl implements OrderDataSource {
  List<OrderModel> orders = [];
  final ApiService apiService;

  OrderDataSourceImpl(this.apiService);

  @override
  List<OrderModel> getOrders() {
    return orders;
  }

  @override
  void addOrder(OrderModel order) {
    int index = -1;
    index = orders.indexWhere((existedOrder) => existedOrder.id == order.id);

    if (index != -1) {
      orders[index].quantity++;
    } else {
      orders.add(order);
    }
  }

  @override
  void deleteOrder(OrderModel order) {
    int index = -1;
    index = orders.indexWhere((existedOrder) => existedOrder.id == order.id);
    orders.removeAt(index);
  }

  @override
  void clearAllOrders() {
    orders.clear();
  }

  @override
  Future<bool> checkout() async {
    int total = 0;

    if (orders.isEmpty) {
      return false;
    }

    for (OrderModel order in orders) {
      total += order.price * order.quantity;
    }

    final body = jsonEncode({
      'total': total,
      'paymentMethod': 2,
      'orderStatus': 1,
      'details': orders.map((order) => order.toJson()).toList()
    });

    final result = await apiService.checkout(body);

    return result;
  }
}
