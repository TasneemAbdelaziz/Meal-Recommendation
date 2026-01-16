import 'package:equatable/equatable.dart';
import 'package:recipe_app_withai/features/add_recipe/domian/entities/recipe_entity.dart';

enum FavoritesStatus { initial, loading, ready, error }

class FavoritesState extends Equatable {
  final FavoritesStatus status;
  final Set<String> favoriteIds;
  final List<RecipeEntity> favoriteRecipes; // ✅ NEW
  final String? errorMessage;

  const FavoritesState({
    required this.status,
    required this.favoriteIds,
    required this.favoriteRecipes,
    required this.errorMessage,
  });

  const FavoritesState.initial()
      : status = FavoritesStatus.initial,
        favoriteIds = const <String>{},
        favoriteRecipes = const <RecipeEntity>[], // ✅ NEW
        errorMessage = null;

  FavoritesState copyWith({
    FavoritesStatus? status,
    Set<String>? favoriteIds,
    List<RecipeEntity>? favoriteRecipes, // ✅ NEW
    String? errorMessage,
    bool clearError = false,
  }) {
    return FavoritesState(
      status: status ?? this.status,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      favoriteRecipes: favoriteRecipes ?? this.favoriteRecipes, // ✅ NEW
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  bool isFavorite(String recipeId) => favoriteIds.contains(recipeId);

  @override
  List<Object?> get props => [status, favoriteIds, favoriteRecipes, errorMessage];
}
