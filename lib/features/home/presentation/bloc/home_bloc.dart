import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app_withai/features/home/domain/recipe_entity.dart';
import 'package:recipe_app_withai/features/home/domain/recipe_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final RecipeRepository repository;

  HomeBloc(this.repository) : super(HomeInitial()) {
    on<LoadSuggestionsEvent>(_onLoadSuggestions);
    on<LoadAllRecipesEvent>(_onLoadAll);
    on<SearchRecipesEvent>(_onSearch);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
  }

  Future<void> _onLoadSuggestions(
      LoadSuggestionsEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final recipes = await repository.getSuggestionsRemote(limit: 5);
      emit(HomeLoaded(recipes));
    } catch (e) {
      emit(HomeError("Failed to load suggestions: $e"));
    }
  }

  Future<void> _onLoadAll(
      LoadAllRecipesEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      await repository.refreshFromRemote();
      emit(HomeLoaded(repository.getAllRecipes()));
    } catch (e) {
      emit(HomeError("Failed to load recipes: $e"));
    }
  }

  Future<void> _onSearch(
      SearchRecipesEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final results = await repository.searchRemote(event.query);
      emit(HomeLoaded(results));
    } catch (e) {
      emit(HomeError("Search failed: $e"));
    }
  }

  void _onToggleFavorite(
      ToggleFavoriteEvent event, Emitter<HomeState> emit) {
    final currentState = state;
    if (currentState is HomeLoaded) {
      final recipes = currentState.recipes.map((recipe) {
        if (recipe.title == event.title) {
          return recipe.copyWith(isFavorite: !recipe.isFavorite);
        }
        return recipe;
      }).toList();
      emit(HomeLoaded(recipes));
    }
  }
}
