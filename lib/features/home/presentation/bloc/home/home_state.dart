part of 'home_bloc.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}

class RecipeUploaded extends HomeState {
  final RecipeEntity recipe;
  RecipeUploaded(this.recipe);
}

class RecipesLoaded extends HomeState {
  final List<RecipeEntity> recipes;
  RecipesLoaded(this.recipes);
}

class FavoriteToggled extends HomeState {
  final RecipeEntity recipe;
  FavoriteToggled(this.recipe);
}
