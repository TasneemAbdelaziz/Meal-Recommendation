import 'dart:io';

import 'package:recipe_app_withai/core/errors/failure.dart';
import 'package:recipe_app_withai/features/add_recipe/data/models/recipe_model.dart';
import 'package:recipe_app_withai/features/add_recipe/domian/entities/ingredient.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class RecipeRemoteDataSource {
  Future<RecipeModel> uploadMeal(RecipeModel recipe);

  Future<String> uploadMealImage({
    required File image,
    required RecipeModel recipe,
  });

  Future<List<String>> uploadIngredientImages({
    required List<Ingredient> ingredients,
    required String recipeId,
  });
}

class RecipeRemoteDataSourceImpl implements RecipeRemoteDataSource {
  final SupabaseClient supabaseClient;

  RecipeRemoteDataSourceImpl(this.supabaseClient);

  // IMPORTANT: ensure this bucket exists in Supabase Storage exactly with same name
  static const String _bucketMealsImages = 'meals_images';

  // IMPORTANT: match your DB table name:
  // If your table is "recipes" (recommended with our SQL), keep this:
  static const String _recipesTable = 'recipes';
  // If you still use "meals", change to: static const String _recipesTable = 'meals';
  
  // Verify table name is correct - should be 'recipes' not 'meals'
  static String get recipesTable => _recipesTable;

  @override
  Future<RecipeModel> uploadMeal(RecipeModel recipe) async {
    print('🌐 DataSource: بدء رفع الوصفة إلى Supabase');
    print('📋 Using table: $_recipesTable');

    try {
      // recipe.toJson() already includes 'ingredientes'
      // Remove 'is_favorite' as it's not a column in the recipes table
      final mealData = recipe.toJson();
      mealData.remove('is_favorite');
      print('📦 Recipe data to insert: ${mealData.keys.toList()}');

      final response = await supabaseClient
          .from(_recipesTable)
          .insert(mealData)
          .select();

      print('✅ Recipe inserted successfully');
      return RecipeModel.fromJson(response.first);
    } catch (e) {
      print('❌ فشل رفع الوصفة: $e');
      print('❌ Error type: ${e.runtimeType}');
      print('❌ Full error details: ${e.toString()}');
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<String> uploadMealImage({
    required File image,
    required RecipeModel recipe,
  }) async {
    try {
      print('📸 رفع صورة الوصفة: ${recipe.id}');

      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        throw ServerFailure('User not authenticated');
      }

      // Build a clean path with extension
      final ext = image.path.split('.').last;
      final path = '$userId/${recipe.id}/main.$ext';

      await supabaseClient.storage.from(_bucketMealsImages).upload(
        path,
        image,
        fileOptions: const FileOptions(upsert: true),
      );

      final publicUrl =
      supabaseClient.storage.from(_bucketMealsImages).getPublicUrl(path);

      print('✅ صورة الوصفة رفعت إلى: $publicUrl');
      return publicUrl;
    } catch (e) {
      print('❌ فشل رفع صورة الوصفة: $e');
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<String>> uploadIngredientImages({
    required List<Ingredient> ingredients,
    required String recipeId,
  }) async {
    print('🖼️ بدء رفع صور المكونات...');
    print('🖼️ عدد المكونات: ${ingredients.length}');

    try {
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        throw ServerFailure('User not authenticated');
      }

      final List<String> uploadedImageUrls = [];

      for (int i = 0; i < ingredients.length; i++) {
        final ingredient = ingredients[i];

        print('🖼️ المكون $i: ${ingredient.name} - الصورة: ${ingredient.imagePath}');

        // No image -> store empty string (or you can store null in your model)
        if (ingredient.imagePath == null || ingredient.imagePath!.isEmpty) {
          print('⚠️ لا يوجد صورة للمكون $i');
          uploadedImageUrls.add('');
          continue;
        }

        final imageFile = File(ingredient.imagePath!);
        if (!imageFile.existsSync()) {
          print('❌ الملف غير موجود: ${imageFile.path}');
          uploadedImageUrls.add('');
          continue;
        }

        final fileExtension = imageFile.path.split('.').last;

        // Make safe file name (avoid spaces/special chars)
        final safeName =
        ingredient.name.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');

        final path =
            '$userId/$recipeId/ingredients/${safeName}_$i.$fileExtension';

        try {
          print('📤 رفع صورة المكون $i إلى: $path');

          await supabaseClient.storage.from(_bucketMealsImages).upload(
            path,
            imageFile,
            fileOptions: const FileOptions(upsert: true),
          );

          final imageUrl =
          supabaseClient.storage.from(_bucketMealsImages).getPublicUrl(path);

          uploadedImageUrls.add(imageUrl);
          print('✅ تم رفع صورة المكون $i: $imageUrl');
        } catch (e) {
          // Keep going even if one upload fails
          uploadedImageUrls.add('');
          print('❌ Failed to upload ingredient image $i: $e');
        }
      }

      print('🎉 انتهاء رفع صور المكونات: $uploadedImageUrls');
      return uploadedImageUrls;
    } catch (e) {
      print('❌ فشل عام في رفع صور المكونات: $e');
      throw ServerFailure('Failed to upload ingredient images: ${e.toString()}');
    }
  }
}
