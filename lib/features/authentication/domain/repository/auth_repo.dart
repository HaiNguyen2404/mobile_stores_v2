import '../entities/user.dart';

abstract class AuthRepo {
  Future<String> login(String username, String password);
  Future<User?> getCurrentUser();
  Future<String> register(String name, String username, String password);
  void logout();
}
