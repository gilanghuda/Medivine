import 'package:medivine/features/domain/entities/user.dart';

class UserModel extends UserEntity {
  UserModel({required super.id, required super.email, String? gender})
      : super(gender: gender);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['uid'],
      email: json['email'],
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': id,
      'email': email,
      if (gender != null) '': gender,
    };
  }
}
