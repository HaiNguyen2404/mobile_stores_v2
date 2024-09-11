import 'package:mobile_store/features/home/data/datasource/product_data_source.dart';
import 'package:mobile_store/features/home/data/models/product_model.dart';
import 'package:mobile_store/features/home/domain/entities/product.dart';
import 'package:mobile_store/features/home/domain/repository/product_repo.dart';

class ProductRepoImpl implements ProductRepo {
  final ProductDataSource dataSource;

  ProductRepoImpl(this.dataSource);

  @override
  Future<List<ProductModel>> fetchProducts() async {
    final products = await dataSource.fetchProducts();

    return products;
  }

  @override
  void refreshProducts() {
    dataSource.refreshProducts();
  }

  @override
  bool checkRemainProducts() {
    return dataSource.checkRemainProducts();
  }
}
