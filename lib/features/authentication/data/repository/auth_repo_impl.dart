import 'package:mobile_store/features/authentication/data/datasources/auth_datasource.dart';
import 'package:mobile_store/features/authentication/data/models/user_model.dart';
import 'package:mobile_store/features/authentication/domain/repository/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthDataSource authDataSource;

  AuthRepoImpl(this.authDataSource);

  @override
  Future<String> login(String username, String password) async {
    try {
      String result = await authDataSource.authenticate(username, password);
      return result;
    } catch (e) {
      throw Exception('Login Failed: $e');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      UserModel? user = await authDataSource.getCurrentUser();
      return user;
    } catch (e) {
      throw Exception('Get user Failed: $e');
    }
  }

  @override
  Future<String> register(String name, String username, String password) async {
    try {
      return await authDataSource.registerUser(name, username, password);
    } catch (e) {
      throw Exception('Unhandled exception: $e');
    }
  }

  @override
  void logout() {
    authDataSource.logout();
  }
}
