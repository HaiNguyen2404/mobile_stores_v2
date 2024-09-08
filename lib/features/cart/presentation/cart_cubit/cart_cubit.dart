import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_store/features/cart/domain/entities/cart.dart';
import 'package:mobile_store/features/cart/domain/usecases/cart_usecases.dart';
import 'package:mobile_store/features/home/domain/entities/product.dart';

import '../../domain/entities/order.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  GetCart getcart;
  AddOrder addOrder;
  DeleteOrder deleteOrder;
  ClearCart clearCart;
  Checkout checkout;

  CartCubit(
    this.getcart,
    this.addOrder,
    this.deleteOrder,
    this.clearCart,
    this.checkout,
  ) : super(CartLoading());

  loadCart() {
    emit(CartLoading());
    try {
      Cart cart = getcart.execute();
      emit(CartLoaded(cart));
    } catch (e) {
      emit(CartError('Failed to get orders: $e'));
    }
  }

  addToCart(Product product) {
    try {
      addOrder.execute(product);
      loadCart();
    } catch (e) {
      throw Exception('Failed to add order: $e');
    }
  }

  deleteAnOrder(Order order) {
    try {
      deleteOrder.execute(order);
      loadCart();
    } catch (e) {
      throw Exception('Failed to delete order: $e');
    }
  }

  deleteOrders() {
    try {
      clearCart.execute();
      loadCart();
    } catch (e) {
      throw Exception('Failed to clear cart: $e');
    }
  }

  Future<bool> checkoutAndClearCart() async {
    try {
      final result = await checkout.execute();
      if (result) {
        deleteOrders();
        return result;
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception('Failed to Checkout: $e');
    }
  }
}
