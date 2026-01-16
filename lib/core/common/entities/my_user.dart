class MyUser {
  final String id;
  final String email;
  final String name;
  final String phone;
  MyUser({required this.id, required this.email, required this.name,required this.phone});

  MyUser copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
  }) {
    return MyUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
    );
  }
}
