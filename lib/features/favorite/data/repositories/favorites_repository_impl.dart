import 'package:fpdart/fpdart.dart';
import 'package:recipe_app_withai/core/errors/failure.dart';
import 'package:recipe_app_withai/features/add_recipe/data/models/recipe_model.dart';
import 'package:recipe_app_withai/features/favorite/data/datasources/favorites_local_datasource.dart';
import 'package:recipe_app_withai/features/favorite/data/datasources/favorites_remote_datasource.dart';
import 'package:recipe_app_withai/features/favorite/domain/repository/favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesRemoteDataSource remote;
  final FavoritesLocalDataSource local;

  FavoritesRepositoryImpl({
    required this.remote,
    required this.local,
  });

  @override
  Future<Either<Failure, Set<String>>> getCachedFavoriteIds() async {
    try {
      final ids = await local.getFavoriteIds();
      return Right(ids);
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(CacheFailure('Failed to read cached favorites: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Set<String>>> syncFavorites(String userId) async {
    try {
      final serverIds = await remote.getFavoriteIds(userId);
      await local.saveFavoriteIds(serverIds);
      return Right(serverIds);
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure('Failed to sync favorites: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Set<String>>> toggleFavorite({
    required String userId,
    required String recipeId,
  }) async {
    try {
      // 1) read cached favorites
      final current = await local.getFavoriteIds();
      final wasFavorite = current.contains(recipeId);

      // 2) optimistic cache update
      final updated = {...current};
      if (wasFavorite) {
        updated.remove(recipeId);
      } else {
        updated.add(recipeId);
      }
      await local.saveFavoriteIds(updated);

      // 3) remote update + rollback on failure
      try {
        if (wasFavorite) {
          await remote.removeFavorite(userId, recipeId);
        } else {
          await remote.addFavorite(userId, recipeId);
        }
        return Right(updated);
      } catch (e) {
        // rollback local cache
        await local.saveFavoriteIds(current);

        // if datasource already throws Failure, keep it
        if (e is Failure) return Left(e);

        return Left(ServerFailure('Toggle favorite failed: ${e.toString()}'));
      }
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure('Toggle favorite failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> addFavorite({
    required String userId,
    required String recipeId,
  }) async {
    try {
      await remote.addFavorite(userId, recipeId);
      return Right(unit);
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure('Failed to add favorite: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeFavorite({
    required String userId,
    required String recipeId,
  }) async {
    try {
      await remote.removeFavorite(userId, recipeId);
      return Right(unit);
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure('Failed to remove favorite: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> clearCachedFavoriteIds() async {
    try {
      await local.clearFavoriteIds();
      return Right(unit);
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(CacheFailure('Failed to clear cached favorites: ${e.toString()}'));
    }
  }

  @override
  Future<List<RecipeModel>> getFavoriteRecipes(Set<String> recipeIds) async {
    final models = await remote.fetchRecipesByIds(recipeIds);
    return models;
  }
}
