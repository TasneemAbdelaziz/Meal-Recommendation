import 'package:recipe_app_withai/features/home/domain/recipe_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/secrets/app_secrets.dart';
class RecipeModel extends RecipeEntity {
  RecipeModel({
    required super.title,
    required super.category,
    required super.ingredientsCount,
    required super.description,
    required super.ingredients,
    required super.durationMinutes,
    super.isFavorite,
  });

  factory RecipeModel.fromEntity(RecipeEntity entity) {
    return RecipeModel(
      title: entity.title,
      category: entity.category,
      ingredientsCount: entity.ingredientsCount,
      description: entity.description,
      ingredients: entity.ingredients,
      durationMinutes: entity.durationMinutes,
      isFavorite: entity.isFavorite,
    );
  }
}

final supabase = SupabaseClient(
  AppSecrets.SupabaseUrl,
  AppSecrets.SupabaseAnnokey,
);
