import 'package:medivine/features/domain/entities/user.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.email,
    String? gender,
    String? name,
    this.role,
  }) : super(gender: gender);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['uid'],
      email: json['email'],
      name: json['name'],
      gender: json['gender'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': id,
      'email': email,
      if (name != null) 'name': name,
      if (gender != null) 'gender': gender,
      if (role != null) 'role': role,
    };
  }

  final String? role;

  get name => null;
}
