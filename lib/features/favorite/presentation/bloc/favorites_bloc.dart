import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app_withai/features/favorite/domain/usecases/GetCachedFavoriteIdsUseCase.dart';
import 'package:recipe_app_withai/features/favorite/domain/usecases/GetFavoriteRecipesUseCase.dart';
import 'package:recipe_app_withai/features/favorite/domain/usecases/SyncFavoritesUseCase.dart';
import 'package:recipe_app_withai/features/favorite/domain/usecases/ToggleFavoriteUseCase.dart';


import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetCachedFavoriteIdsUseCase getCachedFavoriteIdsUseCase;
  final SyncFavoritesUseCase syncFavoritesUseCase;
  final ToggleFavoriteUseCase toggleFavoriteUseCase;

  // final GetFavoriteRecipesUseCase getFavoriteRecipesUseCase;



  FavoritesBloc({
    required this.getCachedFavoriteIdsUseCase,
    required this.syncFavoritesUseCase,
    required this.toggleFavoriteUseCase,
    // required this.getFavoriteRecipesUseCase
  }) : super(const FavoritesState.initial()) {
    on<FavoritesStarted>(_onStarted);
    on<FavoritesRefreshed>(_onRefreshed);
    on<FavoriteToggled>(_onToggled);
    on<FavoritesCacheCleared>(_onCacheCleared);
  }

  Future<void> _onStarted(
      FavoritesStarted event,
      Emitter<FavoritesState> emit,
      ) async {
    emit(state.copyWith(status: FavoritesStatus.loading, clearError: true));

    // 1) Load cached first (fast)
    final cachedResult = await getCachedFavoriteIdsUseCase();
    cachedResult.match(
          (failure) {
        emit(state.copyWith(
          status: FavoritesStatus.error,
          errorMessage: failure.message,
        ));
      },
          (cachedIds) {
        emit(state.copyWith(
          status: FavoritesStatus.ready,
          favoriteIds: cachedIds,
          clearError: true,
        ));
      },
    );

    // 2) Sync from server (source of truth)
    final syncResult = await syncFavoritesUseCase(event.userId);
    syncResult.match(
          (failure) {
        // keep cached ids, but show error
        emit(state.copyWith(
          status: FavoritesStatus.ready,
          errorMessage: failure.message,
        ));
      },
          (serverIds) {
        emit(state.copyWith(
          status: FavoritesStatus.ready,
          favoriteIds: serverIds,
          clearError: true,
        ));
      },
    );
  }

  Future<void> _onRefreshed(
      FavoritesRefreshed event,
      Emitter<FavoritesState> emit,
      ) async {
    // optional: keep ready state but clear error
    emit(state.copyWith(clearError: true));

    final result = await syncFavoritesUseCase(event.userId);
    result.match(
          (failure) => emit(state.copyWith(
        status: FavoritesStatus.ready,
        errorMessage: failure.message,
      )),
          (serverIds) => emit(state.copyWith(
        status: FavoritesStatus.ready,
        favoriteIds: serverIds,
        clearError: true,
      )),
    );
  }

  Future<void> _onToggled(
      FavoriteToggled event,
      Emitter<FavoritesState> emit,
      ) async {
    // optimistic UI update
    final previous = state.favoriteIds;
    final optimistic = {...previous};

    if (optimistic.contains(event.recipeId)) {
      optimistic.remove(event.recipeId);
    } else {
      optimistic.add(event.recipeId);
    }

    emit(state.copyWith(
      status: FavoritesStatus.ready,
      favoriteIds: optimistic,
      clearError: true,
    ));

    // call usecase (repo does remote + cache + rollback if needed)
    final result = await toggleFavoriteUseCase(
      userId: event.userId,
      recipeId: event.recipeId,
    );

    result.match(
          (failure) {
        // rollback UI state
        emit(state.copyWith(
          status: FavoritesStatus.ready,
          favoriteIds: previous,
          errorMessage: failure.message,
        ));
      },
          (updatedIds) {
        // ensure UI matches final state from repo/cache
        emit(state.copyWith(
          status: FavoritesStatus.ready,
          favoriteIds: updatedIds,
          clearError: true,
        ));
      },
    );
  }

  Future<void> _onCacheCleared(
      FavoritesCacheCleared event,
      Emitter<FavoritesState> emit,
      ) async {
    // You can optionally call a usecase that clears cache,
    // but if you already have repository.clearCachedFavoriteIds(),
    // you can do it from a usecase later.
    emit(const FavoritesState.initial());
  }
}
