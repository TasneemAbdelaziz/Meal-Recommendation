import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../../domian/entities/recipe_entity.dart';
import '../../../domian/use_cases/add_recipe_usecase.dart';
import '../../../domian/use_cases/get_recipes.dart';
import '../../../domian/use_cases/toggle_favorite.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final UploadRecipe uploadRecipe;
  final GetRecipes getRecipes;
  final ToggleFavorite toggleFavorite;

  HomeBloc({
    required this.uploadRecipe,
    required this.getRecipes,
    required this.toggleFavorite,
  }) : super(HomeInitial()) {
    on<UploadRecipeEvent>((event, emit) async {
      emit(HomeLoading());
      final result = await uploadRecipe(event.params);
      result.fold(
        (failure) => emit(HomeError(failure.message)),
        (recipe) => emit(RecipeUploaded(recipe)),
      );
    });

    on<GetRecipesEvent>((event, emit) async {
      emit(HomeLoading());
      final result = await getRecipes(NoParams());
      result.fold(
        (failure) => emit(HomeError(failure.message)),
        (recipes) => emit(RecipesLoaded(recipes)),
      );
    });

    on<ToggleFavoriteEvent>((event, emit) async {
      final result = await toggleFavorite(ToggleFavoriteParams(event.recipeId));
      result.fold(
        (failure) => emit(HomeError(failure.message)),
        (recipe) => emit(FavoriteToggled(recipe)),
      );
    });
  }
}
