import 'package:dio/dio.dart';
import 'package:mobile_store/features/home/data/models/product_model.dart';
import 'package:mobile_store/shared/constants/variables.dart';

class ApiService {
  static const limit = 2;

  Future<List<ProductModel>> fetchProducts(int page) async {
    final dio = Dio();
    final response = await dio.get('$baseUrl/products?page=$page&limit=$limit');

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

  Future<bool> checkout(String body, String token) async {
    final dio = Dio(BaseOptions(headers: {'Authorization': 'Bearer $token'}));
    final response = await dio.post('$baseUrl/orders', data: body);

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Checkout failed');
    }
  }
}
