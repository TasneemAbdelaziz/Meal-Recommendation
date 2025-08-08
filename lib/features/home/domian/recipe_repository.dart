import 'recipe_entity.dart';

abstract class RecipeRepository {
  List<RecipeEntity> getAllRecipes();
  void addRecipe(RecipeEntity recipe);
  void toggleFavorite(RecipeEntity recipe);
  List<RecipeEntity> getFavoriteRecipes();
}

