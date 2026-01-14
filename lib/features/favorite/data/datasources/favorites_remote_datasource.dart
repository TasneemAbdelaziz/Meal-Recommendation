import 'package:recipe_app_withai/core/errors/failure.dart';
import 'package:recipe_app_withai/features/add_recipe/data/models/recipe_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class FavoritesRemoteDataSource {
  Future<Set<String>> getFavoriteIds(String userId);
  Future<void> addFavorite(String userId, String recipeId);
  Future<void> removeFavorite(String userId, String recipeId);
  Future<List<RecipeModel>> fetchRecipesByIds(Set<String> ids);
}

class FavoritesRemoteDataSourceImpl implements FavoritesRemoteDataSource {
  final SupabaseClient supabaseClient;

  FavoritesRemoteDataSourceImpl(this.supabaseClient);

  static const String _favoritesTable = 'recipe_favorites';


  @override
  Future<List<RecipeModel>> fetchRecipesByIds(Set<String> ids) async {
    if (ids.isEmpty) return [];

    final res = await Supabase.instance.client
        .from('recipes')
        .select()
        .inFilter('id', ids.toList())
        .order('updated_at', ascending: false);

    return (res as List<dynamic>)
        .map((e) => RecipeModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Set<String>> getFavoriteIds(String userId) async {
    try {
      final response = await supabaseClient
          .from(_favoritesTable)
          .select('recipe_id')
          .eq('user_id', userId);

      if (response == null) {
        return <String>{};
      }

      final List<dynamic> favorites = response as List<dynamic>;
      return favorites
          .map((item) => item['recipe_id'] as String)
          .toSet();
    } on PostgrestException catch (e) {
      throw ServerFailure('Failed to fetch favorites: ${e.message}');
    } catch (e) {
      throw ServerFailure('Unexpected error fetching favorites: ${e.toString()}');
    }
  }

  @override
  Future<void> addFavorite(String userId, String recipeId) async {
    try {
      await supabaseClient
          .from(_favoritesTable)
          .insert({
            'user_id': userId,
            'recipe_id': recipeId,
          });
    } on PostgrestException catch (e) {
      // If already exists, that's okay (idempotent)
      if (e.code != '23505') { // Not a unique constraint violation
        throw ServerFailure('Failed to add favorite: ${e.message}');
      }
    } catch (e) {
      throw ServerFailure('Unexpected error adding favorite: ${e.toString()}');
    }
  }

  @override
  Future<void> removeFavorite(String userId, String recipeId) async {
    try {
      await supabaseClient
          .from(_favoritesTable)
          .delete()
          .eq('user_id', userId)
          .eq('recipe_id', recipeId);
    } on PostgrestException catch (e) {
      throw ServerFailure('Failed to remove favorite: ${e.message}');
    } catch (e) {
      throw ServerFailure('Unexpected error removing favorite: ${e.toString()}');
    }
  }
}
