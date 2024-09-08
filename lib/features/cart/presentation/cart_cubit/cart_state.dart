part of 'cart_cubit.dart';

class CartState {
  CartState();
}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  Cart cart;

  CartLoaded(this.cart);
}

class CartEmty extends CartState {
  static const message = 'Cart is Emty';
}

class CartError extends CartState {
  String message;

  CartError(this.message);
}
