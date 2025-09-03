import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:recipe_app_withai/features/home/data/models/recipe_model.dart';
import 'package:recipe_app_withai/features/home/domain/entities/recipe_entity.dart';
import 'package:recipe_app_withai/features/home/domain/repositories/home_repository.dart';
import 'package:recipe_app_withai/core/usecase/usecase.dart';
import '../../domain/use_cases/get_all_recipes.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetAllRecipes _getAllRecipes;

  HomeBloc({required  GetAllRecipes getAllRecipes}) :
        _getAllRecipes = getAllRecipes,

        super(HomeInitial()) {

    // on<LoadSuggestionsEvent>(_onLoadSuggestions);
    on<LoadAllRecipesEvent>(_onLoadAll);
    // on<SearchRecipesEvent>(_onSearch);
    // on<ToggleFavoriteEvent>(_onToggleFavorite);
  }

  // Future<void> _onLoadSuggestions(
  //     LoadSuggestionsEvent event, Emitter<HomeState> emit) async {
  //   emit(HomeLoading());
  //   try {
  //     final recipes = await _getAllRecipes();
  //     emit(HomeLoaded(recipes));
  //   } catch (e) {
  //     emit(HomeError("Failed to load suggestions: $e"));
  //   }
  // }

  Future<void> _onLoadAll(
      LoadAllRecipesEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    final result = await _getAllRecipes.call(NoParams());
    result.fold(
          (failure) => emit(HomeError("Failed to load recipes: ${failure.message}")),
          (recipes) => emit(HomeLoaded(recipes)),
    );
  }

  // Future<void> _onSearch(
  //     SearchRecipesEvent event, Emitter<HomeState> emit) async {
  //   emit(HomeLoading());
  //   try {
  //     final results = await repository.searchRemote(event.query);
  //     emit(HomeLoaded(results));
  //   } catch (e) {
  //     emit(HomeError("Search failed: $e"));
  //   }
  // }
  //
  // void _onToggleFavorite(
  //     ToggleFavoriteEvent event, Emitter<HomeState> emit) {
  //   final currentState = state;
  //   if (currentState is HomeLoaded) {
  //     final recipes = currentState.recipes.map((recipe) {
  //       if (recipe.title == event.title) {
  //         return recipe.copyWith(isFavorite: !recipe.isFavorite);
  //       }
  //       return recipe;
  //     }).toList();
  //     emit(HomeLoaded(recipes));
  //   }
  // }
}
