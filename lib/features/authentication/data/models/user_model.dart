import 'package:mobile_store/features/authentication/domain/entities/user.dart';

class UserModel extends User {
  UserModel({required super.name, required super.token});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      token: json['token'],
    );
  }
}
