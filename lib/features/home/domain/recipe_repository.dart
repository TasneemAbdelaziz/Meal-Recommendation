import 'recipe_entity.dart';

abstract class RecipeRepository {
  List<RecipeEntity> getAllRecipes();
  void addRecipe(RecipeEntity recipe);
  void toggleFavorite(RecipeEntity recipe);
  List<RecipeEntity> getFavoriteRecipes();
  
  // Remote methods for Supabase integration
  Future<void> refreshFromRemote();
  Future<List<RecipeEntity>> searchRemote(String query);
  Future<List<RecipeEntity>> getSuggestionsRemote({int limit = 5});
  Future<void> addRecipeRemote(RecipeEntity recipe);
}
