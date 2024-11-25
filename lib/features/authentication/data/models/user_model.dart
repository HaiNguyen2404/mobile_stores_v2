import 'package:mobile_store/features/authentication/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.name,
    required super.token,
  });
}
