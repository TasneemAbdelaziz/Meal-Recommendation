import 'package:recipe_app_withai/core/common/entities/my_user.dart';
class UserModel extends MyUser {
  UserModel({required super.id, required super.email, required super.name,required super.phone});

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id']??"",
      email: map['email']??"",
      name: map['name']??"",
      phone: map['phone']??""

    );
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
  }) {
    return UserModel(
        id: id ?? this.id, email: email ?? this.email, name: name ?? this.name,phone: phone??this.phone);
  }
}
