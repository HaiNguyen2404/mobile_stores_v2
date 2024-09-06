import '../entities/product.dart';

abstract class ProductRepo {
  Future<List<Product>> fetchProducts();
  void refreshProducts();
  bool checkRemainProducts();
}
