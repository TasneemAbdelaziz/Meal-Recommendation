import 'package:recipe_app_withai/features/home/data/models/recipe_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class HomeRemoteDataSource {
  Future<List<RecipeModel>> getAllRecipes();
  Future<List<RecipeModel>> searchRecipes(String query);
  Future<List<RecipeModel>> getRecipesByDuration(int maxDuration);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource{
  final SupabaseClient supabaseClient;

  HomeRemoteDataSourceImpl({required this.supabaseClient});

  // @override
  // Future<RecipeModel> getRecipe(String recipeId) async {
  //   try {
  //     final response = await supabaseClient
  //         .from('recipes')
  //         .select()
  //         .eq('id', recipeId)
  //         .single();
  //
  //     return RecipeModel.fromJson(response);
  //   } on PostgrestException catch (e) {
  //     throw Exception('Failed to fetch recipe: ${e.message}');
  //   } catch (e) {
  //     throw Exception('Failed to fetch recipe: $e');
  //   }
  // }

  @override
  Future<List<RecipeModel>> getAllRecipes() async {
    try {
      final response = await supabaseClient
          .from('meals')
          .select('*')
          .order('title');

      return (response as List)
          .map((recipe) => RecipeModel.fromJson(recipe))
          .toList();
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch recipes: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch recipes: $e');
    }
  }

  @override
  Future<List<RecipeModel>> searchRecipes(String query) async {
    try {
      final response = await supabaseClient
          .from('recipes')
          .select('id, title, main_image_url, duration')
          .ilike('title', '%$query%')
          .order('title');

      return (response as List)
          .map((recipe) => RecipeModel.fromJson(recipe))
          .toList();
    } on PostgrestException catch (e) {
      throw Exception('Failed to search recipes: ${e.message}');
    } catch (e) {
      throw Exception('Failed to search recipes: $e');
    }
  }

  @override
  Future<List<RecipeModel>> getRecipesByDuration(int maxDuration) async {
    try {
      final response = await supabaseClient
          .from('recipes')
          .select('id, title, main_image_url, duration')
          .lte('duration', maxDuration)
          .order('duration');

      return (response as List)
          .map((recipe) => RecipeModel.fromJson(recipe))
          .toList();
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch recipes by duration: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch recipes by duration: $e');
    }
  }
  
}