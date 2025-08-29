part of 'home_bloc.dart';

abstract class HomeEvent {}

class UploadRecipeEvent extends HomeEvent {
  final UploadRecipeParams params;
  UploadRecipeEvent(this.params);
}

class GetRecipesEvent extends HomeEvent {}

class ToggleFavoriteEvent extends HomeEvent {
  final String recipeId;
  ToggleFavoriteEvent(this.recipeId);
}
