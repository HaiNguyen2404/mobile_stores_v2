import 'package:mobile_store/features/home/domain/entities/product.dart';
import 'package:mobile_store/features/home/domain/repository/product_repo.dart';

class FetchProduct {
  final ProductRepo productRepo;

  FetchProduct(this.productRepo);

  Future<List<Product>> execute() => productRepo.fetchProducts();
}

class RefreshProduct {
  final ProductRepo productRepo;

  RefreshProduct(this.productRepo);

  void execute() {
    productRepo.refreshProducts();
  }
}

class CheckRemainProduct {
  final ProductRepo productRepo;

  CheckRemainProduct(this.productRepo);

  bool execute() => productRepo.checkRemainProducts();
}
