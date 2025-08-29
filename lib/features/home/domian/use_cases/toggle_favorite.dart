import 'package:fpdart/fpdart.dart';
import 'package:recipe_app_withai/core/errors/failure.dart';
import 'package:recipe_app_withai/core/usecase/usecase.dart';
import '../entities/recipe_entity.dart';
import '../repositories/recipe_repository.dart';

class ToggleFavoriteParams {
  final String recipeId;

  ToggleFavoriteParams(this.recipeId);
}

class ToggleFavorite implements UseCase<RecipeEntity, ToggleFavoriteParams> {
  final RecipeRepository repository;

  ToggleFavorite(this.repository);

  @override
  Future<Either<Failure, RecipeEntity>> call(
      ToggleFavoriteParams params) async {
    return await repository.toggleFavorite(params.recipeId);
  }
}
