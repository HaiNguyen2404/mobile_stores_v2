import 'package:mobile_store/features/home/data/datasource/api_service.dart';
import 'package:mobile_store/features/home/data/models/product_model.dart';

abstract class ProductDataSource {
  Future<List<ProductModel>> fetchProducts();
  void refreshProducts();
  bool checkRemainProducts();
}

class ProductDataSourceImpl implements ProductDataSource {
  final ApiService apiService;
  int page = 1;
  static const limit = 2;
  bool hasMore = true;

  List<ProductModel> currentProducts = [];

  ProductDataSourceImpl(this.apiService);

  @override
  Future<List<ProductModel>> fetchProducts() async {
    List<ProductModel> products = [];
    if (hasMore) {
      products = await apiService.fetchProducts(page);
      if (products.length < limit) {
        hasMore = false;
      } else {
        page++;
      }
    }
    currentProducts.addAll(products);

    return currentProducts;
  }

  @override
  void refreshProducts() {
    page = 1;
    hasMore = true;
    currentProducts = [];
  }

  @override
  bool checkRemainProducts() {
    if (hasMore) {
      return true;
    } else {
      return false;
    }
  }
}
