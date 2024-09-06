part of 'product_cubit.dart';

class ProductState {
  ProductState();
}

class LoadedProductState extends ProductState {
  final List<Product> products;

  LoadedProductState(this.products);
}

class EmptyState extends ProductState {
  final String message = 'There is no product';

  EmptyState();
}

class LoadingState extends ProductState {
  LoadingState();
}

class ErrorState extends ProductState {
  final String message;

  ErrorState(this.message);
}
