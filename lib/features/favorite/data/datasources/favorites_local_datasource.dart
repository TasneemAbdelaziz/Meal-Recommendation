import 'package:recipe_app_withai/core/errors/failure.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class FavoritesLocalDataSource {
  Set<String> getFavoriteIds(); // دي ممكن تبقى sync
  Future<void> saveFavoriteIds(Set<String> favoriteIds);
  Future<void> clearFavoriteIds();
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  final SharedPreferences sharedPreferences;

  FavoritesLocalDataSourceImpl(this.sharedPreferences);

  static const String _favoritesKey = 'cached_favorite_ids';



  @override
  Set<String> getFavoriteIds() {
    try {
      final list = sharedPreferences.getStringList(_favoritesKey) ?? const <String>[];
      return list.toSet();
    } catch (e) {
      throw CacheFailure('Failed to read cached favorites: ${e.toString()}');
    }
  }

  @override
  Future<void> saveFavoriteIds(Set<String> favoriteIds) async {
    try {
      await sharedPreferences.setStringList(_favoritesKey, favoriteIds.toList());
    } catch (e) {
      throw CacheFailure('Failed to save cached favorites: ${e.toString()}');
    }
  }

  @override
  Future<void> clearFavoriteIds() async {
    try {
      await sharedPreferences.remove(_favoritesKey);
    } catch (e) {
      throw CacheFailure('Failed to clear cached favorites: ${e.toString()}');
    }
  }
}
