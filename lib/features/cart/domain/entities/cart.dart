import 'package:mobile_store/features/cart/domain/entities/order.dart';

class Cart {
  final List<Order> orderList;

  Cart({required this.orderList});

  double grandTotal() {
    double total = 0;
    for (Order order in orderList) {
      total = total + order.price * order.quantity;
    }

    return total;
  }
}
