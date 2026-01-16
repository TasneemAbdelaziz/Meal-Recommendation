import 'package:fpdart/fpdart.dart';
import 'package:recipe_app_withai/core/errors/failure.dart';
import 'package:recipe_app_withai/features/favorite/domain/repository/favorites_repository.dart';

class SyncFavoritesUseCase {
  final FavoritesRepository repository;

  SyncFavoritesUseCase(this.repository);

  Future<Either<Failure, Set<String>>> call(String userId) {
    return repository.syncFavorites(userId);
  }
}
