class FavoriteRecordModel {
  final String userId;
  final String recipeId;
  final DateTime? createdAt;

  const FavoriteRecordModel({
    required this.userId,
    required this.recipeId,
    this.createdAt,
  });

  factory FavoriteRecordModel.fromJson(Map<String, dynamic> json) {
    return FavoriteRecordModel(
      userId: json['user_id']?.toString() ?? '',
      recipeId: json['recipe_id']?.toString() ?? '',
      createdAt: json['created_at'] == null
          ? null
          : DateTime.tryParse(json['created_at'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'recipe_id': recipeId,
    };
  }
}
