import 'package:fpdart/fpdart.dart';
import 'package:recipe_app_withai/core/errors/failure.dart';
import 'package:recipe_app_withai/features/favorite/domain/repository/favorites_repository.dart';

class ToggleFavoriteUseCase {
  final FavoritesRepository repository;

  ToggleFavoriteUseCase(this.repository);

  Future<Either<Failure, Set<String>>> call({
    required String userId,
    required String recipeId,
  }) {
    return repository.toggleFavorite(
      userId: userId,
      recipeId: recipeId,
    );
  }
}
