import '../entities/user.dart';
import '../repository/auth_repo.dart';

class Login {
  final AuthRepo repository;

  Login(this.repository);

  Future<String> execute(String username, String password) async {
    return await repository.login(username, password);
  }
}

class Logout {
  final AuthRepo repository;

  Logout(this.repository);

  void execute() {
    repository.logout();
  }
}

class GetCurrentUser {
  final AuthRepo repository;

  GetCurrentUser(this.repository);

  Future<User?> execute() async {
    return await repository.getCurrentUser();
  }
}

class Register {
  final AuthRepo repository;

  Register(this.repository);

  Future<String> execute(String name, String username, String password) async {
    return await repository.register(name, username, password);
  }
}
