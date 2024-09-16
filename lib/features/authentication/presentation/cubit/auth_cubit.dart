import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_store/features/authentication/domain/usecases/auth_usecases.dart';

import '../../domain/entities/user.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final Login login;
  final GetCurrentUser getCurrentUser;
  final Register register;
  final Logout logout;

  AuthCubit(
    this.login,
    this.logout,
    this.getCurrentUser,
    this.register,
  ) : super(AuthInitial());

  Future<void> loginAndGetToken(
    String username,
    String password,
  ) async {
    try {
      final result = await login.execute(username, password);

      if (result == "Success") {
        User? user = await getCurrentUser.execute();
        if (user != null) {
          emit(AuthLoaded(user));
        } else {
          emit(AuthInitial());
        }
      } else {
        emit(AuthError(result));
      }
    } on Exception catch (_) {
      emit(AuthError("Invalid username or password"));
    }
  }

  Future<bool> checkUserState() async {
    User? user = await getCurrentUser.execute();
    if (user != null) {
      emit(AuthLoaded(user));
      return true;
    } else {
      emit(AuthInitial());
      return false;
    }
  }

  registerUser(String name, String username, String password) async {
    try {
      await register.execute(name, username, password);

      loginAndGetToken(username, password);
    } on Exception catch (_) {
      emit(AuthError("Username already exists"));
    }
  }

  logoutAndLoadState() {
    logout.execute();
    checkUserState();
  }
}
