import 'dart:convert';
import 'package:mobile_store/models/product.dart';
import 'package:dio/dio.dart';

class ProductRepository {
  int page = 1;
  static const limit = 2;
  bool hasMore = true;
  List<Product> currentProducts = [];

  Future<List<Product>> fetchProducts() async {
    final url =
        'http://192.168.0.9:8080/api/v2/products?page=$page&limit=$limit';

    final dio = Dio(BaseOptions(responseType: ResponseType.plain));
    final response = await dio.get(url);

    final data = jsonDecode(response.data);
    final products = data['content']
        .map<Product>((product) => Product.fromJson(product))
        .toList();

    if (response.statusCode == 200) {
      if (products.length < limit) {
        hasMore = false;
      }

      page++;
      currentProducts.addAll(products);

      return currentProducts;
    } else {
      throw Exception('Failed to fetch products');
    }
  }

  void productsRefresh() {
    page = 1;
    currentProducts.clear();
    hasMore = true;
  }
}
