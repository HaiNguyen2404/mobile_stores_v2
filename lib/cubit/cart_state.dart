abstract class CartState {
  const CartState();
}

class CartInitial extends CartState {
  CartInitial();
}

class CartItemLoaded extends CartState {
  final List<Map<dynamic, dynamic>> cartList;
  double grandTotal;
  CartItemLoaded({required this.cartList, required this.grandTotal});
}

class CartError extends CartState {
  final String error;
  CartError({required this.error});
}
