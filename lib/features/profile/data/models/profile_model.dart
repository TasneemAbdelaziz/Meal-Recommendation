import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  ProfileModel({
    required String id,
    required String username,
    required String email,
    String? avatarUrl,
    String? phone,
  }) : super(
          id: id,
          username: username,
          email: email,
          avatarUrl: avatarUrl,
          phone: phone,
        );

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        id: json['id'],
        username: json['username'],
        email: json['email'],
        avatarUrl: json['avatar_url'],
        phone: json['phone'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'avatar_url': avatarUrl,
        'phone': phone,
      };
}
