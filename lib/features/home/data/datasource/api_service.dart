import 'package:dio/dio.dart';
import 'package:mobile_store/features/home/data/models/product_model.dart';

class ApiService {
  static const baseUrl = "http://10.0.2.2:8080/api/v2/products";
  static const limit = 2;

  Future<List<ProductModel>> fetchProducts(int page) async {
    final dio = Dio();
    final response = await dio.get('$baseUrl?page=$page&limit=$limit');

    if (response.statusCode == 200) {
      final data = response.data;

      final products = data['content']
          .map<ProductModel>((json) => ProductModel.fromJson(json))
          .toList();

      return products;
    } else {
      throw Exception("Fetching Products error");
    }
  }
}