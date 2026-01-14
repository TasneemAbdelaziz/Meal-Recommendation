class ProfileEntity {
  final String id;
  final String username;
  final String email;
  final String? avatarUrl;
  final String? phone;

  ProfileEntity({
    required this.id,
    required this.username,
    required this.email,
    this.avatarUrl,
    this.phone,
  });
}
