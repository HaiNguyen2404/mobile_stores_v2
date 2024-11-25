import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_store/features/authentication/data/models/user_model.dart';
import 'package:mobile_store/shared/constants/variables.dart';

abstract class AuthDataSource {
  Future<void> authenticate(String username, String password);
  Future<UserModel?> getCurrentUser();
  Future<String> registerUser(String name, String username, String password);
  void logout();
}

class AuthDataSourceImpl implements AuthDataSource {
  final tokenBox = Hive.box('token_box');

  @override
  Future<void> authenticate(String username, String password) async {
    final dio = Dio();
    const url = '$baseUrl/users/login';
    final response = await dio.post(
      url,
      data: {'username': username, 'password': password},
    );

    if (response.statusCode == 200) {
      tokenBox.put(1, response.data);
    } else {
      throw Exception("Login Failed");
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    if (!tokenBox.keys.contains(1)) {
      tokenBox.put(1, '');
    }
    String authToken = tokenBox.get(1);

    final dio = Dio(BaseOptions(
      headers: {"Authorization": "Bearer $authToken"},
    ));
    const url = '$baseUrl/users/auth/me';
    if (authToken == '') {
      return null;
    }

    final response = await dio.get(url);

    if (response.statusCode != 200) {
      return null;
    }

    if (response.data.keys.contains('error')) {
      logout();
      return null;
    }

    return UserModel(name: response.data['name'], token: authToken);
  }

  @override
  Future<String> registerUser(
    String name,
    String username,
    String password,
  ) async {
    final dio = Dio();
    const url = '$baseUrl/users/register';
    const existed = 'Username already exists.';

    final data = {
      'name': name,
      'username': username,
      'password': password,
    };

    final response = await dio.post(url, data: data);

    if (response.statusCode == 200) {
      if (response.data == existed) {
        throw Exception();
      } else {
        return "Register Successful";
      }
    } else {
      throw Exception('Register Failed');
    }
  }

  @override
  void logout() {
    tokenBox.put(1, '');
  }
}
