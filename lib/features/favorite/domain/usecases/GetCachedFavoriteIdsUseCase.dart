import 'package:fpdart/fpdart.dart';
import 'package:recipe_app_withai/core/errors/failure.dart';
import 'package:recipe_app_withai/features/favorite/domain/repository/favorites_repository.dart';

class GetCachedFavoriteIdsUseCase {
  final FavoritesRepository repository;

  GetCachedFavoriteIdsUseCase(this.repository);

  Future<Either<Failure, Set<String>>> call() {
    return repository.getCachedFavoriteIds();
  }
}
