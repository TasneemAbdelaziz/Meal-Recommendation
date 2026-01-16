import 'package:equatable/equatable.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

/// Load cached favorites then sync from server
class FavoritesStarted extends FavoritesEvent {
  final String userId;
  const FavoritesStarted(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// Force sync from server
class FavoritesRefreshed extends FavoritesEvent {
  final String userId;
  const FavoritesRefreshed(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// Toggle favorite for a given recipe (optimistic UI)
class FavoriteToggled extends FavoritesEvent {
  final String userId;
  final String recipeId;
  const FavoriteToggled({
    required this.userId,
    required this.recipeId,
  });

  @override
  List<Object?> get props => [userId, recipeId];
}

/// Clear local cache (e.g., on logout)
class FavoritesCacheCleared extends FavoritesEvent {
  const FavoritesCacheCleared();
}
