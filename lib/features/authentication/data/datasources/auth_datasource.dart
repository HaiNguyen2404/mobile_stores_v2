import 'package:dio/dio.dart';
import 'package:mobile_store/features/authentication/data/models/user_model.dart';

abstract class AuthDataSource {
  Future<String> authenticate(String username, String password);
  Future<UserModel?> getCurrentUser();
  Future<String> registerUser(String name, String username, String password);
  void logout();
}

class AuthDataSourceImpl implements AuthDataSource {
  String authToken = "";

  @override
  Future<String> authenticate(String username, String password) async {
    final dio = Dio();
    const url = 'http://10.0.2.2:8080/api/v2/users/login';
    final response = await dio.post(
      url,
      data: {'username': username, 'password': password},
    );

    if (response.statusCode == 200) {
      authToken = response.data;
      return "Login Success";
    } else {
      return "Invalid username or password";
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final dio = Dio(BaseOptions(
      headers: {"Authorization": "Bearer $authToken"},
    ));
    const url = 'http://10.0.2.2:8080/api/v2/users/auth/me';
    if (authToken != "") {
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        return UserModel(name: response.data['name'], token: authToken);
      }
      return null;
    }
    return null;
  }

  @override
  Future<String> registerUser(
    String name,
    String username,
    String password,
  ) async {
    final dio = Dio();
    const url = 'http://10.0.2.2:8080/api/v2/users/register';
    const existed = 'Username already exists.';

    final data = {
      'name': name,
      'username': username,
      'password': password,
    };

    final response = await dio.post(url, data: data);

    if (response.statusCode == 200) {
      if (response.data == existed) {
        return existed;
      } else {
        return "Register Successful";
      }
    } else {
      throw Exception('Register Failed');
    }
  }

  @override
  void logout() {
    authToken = '';
  }
}
