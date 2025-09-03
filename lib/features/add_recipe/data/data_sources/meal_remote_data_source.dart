import 'dart:io';

import 'package:recipe_app_withai/core/errors/failure.dart';
import 'package:recipe_app_withai/features/add_recipe/data/models/recipe_model.dart';
import 'package:recipe_app_withai/features/add_recipe/domian/entities/ingredient.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
abstract interface class RecipeRemoteDataSource{
  Future<RecipeModel> uploadMeal(RecipeModel recipe);
  Future<String> uploadMealImage(
  {required File image,
    required RecipeModel recipe});
  Future<List<String>> uploadIngredientImages({
    required List<Ingredient> ingredients,
    required String recipeId
  });
}

class RecipeRemoteDataSourceImpl implements RecipeRemoteDataSource{
  final SupabaseClient supabaseClient;
  RecipeRemoteDataSourceImpl(this.supabaseClient);
  @override
  Future<RecipeModel> uploadMeal(RecipeModel recipe) async{
    print('🌐 DataSource: بدء رفع الوصفة إلى Supabase');

    try {
      final ingredientsJson = recipe.ingredients.map((ingredient) => {
        'name': ingredient.name,
        'image_url': ingredient.imagePath,
      }).toList();

      final mealData = {
        ...recipe.toJson(),
        'ingredientes': ingredientsJson,
      };

      final response = await supabaseClient
          .from('meals')
          .insert(mealData)
          .select();

      return RecipeModel.fromJson(response.first);
    } catch (e) {
      print('❌ فشل رفع الوصفة: $e');

      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<String> uploadMealImage({required File image, required RecipeModel recipe}) async{
   try{
     print('📸 رفع صورة الوصفة: ${recipe.id}');

     await supabaseClient.storage.from('meals_images').upload(recipe.id, image);
     print('✅ صورة الوصفة رفعت إلى: $image');

     return supabaseClient.storage.from('meals_images').getPublicUrl(recipe.id);

   }catch(e){
     print('❌ فشل رفع صورة الوصفة: $e');

     throw ServerFailure(e.toString());
   }
  }


  @override
  Future<List<String>> uploadIngredientImages({
    required List<Ingredient> ingredients,
    required String recipeId
  }) async {
    print('🖼️ بدء رفع صور المكونات...');
    print('🖼️ عدد المكونات: ${ingredients.length}');
    try {

      final List<String> uploadedImageUrls = [];

      for (int i = 0; i < ingredients.length; i++) {
        final ingredient = ingredients[i];
        print('🖼️ المكون $i: ${ingredient.name} - الصورة: ${ingredient.imagePath}');

        if (ingredient.imagePath != null && ingredient.imagePath!.isNotEmpty) {
          print('📤 رفع صورة المكون $i: ${ingredient.imagePath}');

          try {
            final imageFile = File(ingredient.imagePath!);
            final fileExtension = imageFile.path.split('.').last;
            final fileName = '${recipeId}_ingredient_$i.$fileExtension';

            await supabaseClient.storage
                .from('meals_images')
                .upload(fileName, imageFile);

            final imageUrl = supabaseClient.storage
                .from('meals_images')
                .getPublicUrl(fileName);

            uploadedImageUrls.add(imageUrl);
          } catch (e) {

            uploadedImageUrls.add('');
            print('Failed to upload ingredient image $i: $e');
          }
        } else {
          final imageFile = File(ingredient.imagePath!);
          print('❌ الملف غير موجود: ${imageFile.path}');
          uploadedImageUrls.add('');
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