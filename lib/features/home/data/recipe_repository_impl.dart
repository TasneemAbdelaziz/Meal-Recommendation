import 'package:recipe_app_withai/features/home/domain/recipe_repository.dart';
import 'package:recipe_app_withai/features/home/domain/recipe_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/secrets/app_secrets.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final SupabaseClient client = SupabaseClient(
    AppSecrets.SupabaseUrl,
    AppSecrets.SupabaseAnnokey,
  );

  final List<RecipeEntity> _recipes = [];
  
  @override
  List<RecipeEntity> getAllRecipes() => List.unmodifiable(_recipes);

  @override
  void addRecipe(RecipeEntity recipe) {
    _recipes.add(recipe);
  }

  @override
  void toggleFavorite(RecipeEntity recipe) {
    final index = _recipes.indexOf(recipe);
    if (index != -1) {
      _recipes[index] = recipe.copyWith(isFavorite: !recipe.isFavorite);
    }
  }

  @override
  List<RecipeEntity> getFavoriteRecipes() =>
      _recipes.where((r) => r.isFavorite).toList();

  @override
  Future<void> refreshFromRemote() async {
    try {
      final data = await client.from('recipes').select();
      final List<RecipeEntity> mapped =
          (data as List).map((r) => RecipeEntity.fromMap(r)).toList();

      _recipes
        ..clear()
        ..addAll(mapped);
    } catch (e) {
      throw Exception('Failed to refresh recipes from remote: $e');
    }
  }

  @override
  Future<List<RecipeEntity>> searchRemote(String query) async {
    try {
      final data = await client
          .from('recipes')
          .select()
          .ilike('title', '%$query%')
          .order('title');
      return (data as List).map((r) => RecipeEntity.fromMap(r)).toList();
    } catch (e) {
      throw Exception('Failed to search recipes: $e');
    }
  }

  @override
  Future<List<RecipeEntity>> getSuggestionsRemote({int limit = 5}) async {
    try {
      final data = await client
          .from('recipes')
          .select()
          .limit(limit)
          .order('created_at', ascending: false);
      return (data as List).map((r) => RecipeEntity.fromMap(r)).toList();
    } catch (e) {
      throw Exception('Failed to get recipe suggestions: $e');
    }
  }

  @override
  Future<void> addRecipeRemote(RecipeEntity recipe) async {
    try {
      await client.from('recipes').insert(recipe.toMap());
      _recipes.add(recipe);
    } catch (e) {
      throw Exception('Failed to add recipe to remote: $e');
    }
  }
}
