import 'package:mobile_store/features/home/domain/entities/product.dart';

import '../entities/cart.dart';
import '../entities/order.dart';
import '../repositories/cart_repo.dart';

class GetCart {
  final CartRepo cartRepo;

  GetCart(this.cartRepo);

  Cart execute() {
    return cartRepo.getCart();
  }
}

class AddOrder {
  final CartRepo cartRepo;

  AddOrder(this.cartRepo);

  void execute(Product product) {
    cartRepo.addOrder(product);
  }
}

class DeleteOrder {
  final CartRepo cartRepo;

  DeleteOrder(this.cartRepo);

  void execute(Order order) {
    cartRepo.deleteOrder(order);
  }
}

class ClearCart {
  final CartRepo cartRepo;

  ClearCart(this.cartRepo);

  void execute() {
    cartRepo.clearCart();
  }
}

class Checkout {
  final CartRepo cartRepo;

  Checkout(this.cartRepo);

  Future<bool> execute() async {
    return await cartRepo.checkout();
  }
}
