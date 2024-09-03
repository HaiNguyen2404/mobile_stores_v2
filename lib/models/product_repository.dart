import 'dart:convert';
import 'package:mobile_store/models/product.dart';
import 'package:dio/dio.dart';

class ProductRepository {
  int page = 1;
  static const limit = 2;
  bool hasMore = true;
  List<Product> currentProducts = [];
  Dio dio;

  ProductRepository({required this.dio});

  Future<List<Product>> fetchProducts() async {
    final url = 'http://10.0.2.2:8080/api/v2/products?page=$page&limit=$limit';
    final response = await dio.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.data);
      if (data['content'] == null) {
        throw Exception('Data Error');
      }

      final products = data['content']
          .map<Product>((product) => Product.fromJson(product))
          .toList();

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
