import 'package:recipe_app_withai/features/add_recipe/data/models/recipe_model.dart';
import 'package:recipe_app_withai/features/add_recipe/domian/entities/recipe_entity.dart';
import 'package:recipe_app_withai/features/favorite/domain/repository/favorites_repository.dart';

class GetFavoriteRecipesUseCase {
  final FavoritesRepository repo;
  GetFavoriteRecipesUseCase(this.repo);

  Future<List<RecipeModel>> call(Set<String> ids) {
    return repo.getFavoriteRecipes(ids);
  }
}
