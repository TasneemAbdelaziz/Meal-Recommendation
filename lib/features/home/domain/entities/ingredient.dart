class Ingredient {
  final String name;
  final String? imagePath;

  Ingredient({
    required this.name,
    this.imagePath,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Ingredient &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              imagePath == other.imagePath;

  @override
  int get hashCode => name.hashCode ^ imagePath.hashCode;

  Ingredient copyWith({
    String? name,
    String? imagePath,
  }) {
    return Ingredient(
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}