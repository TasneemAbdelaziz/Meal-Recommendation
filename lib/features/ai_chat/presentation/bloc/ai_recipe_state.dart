part of 'ai_recipe_bloc.dart';

sealed class AiRecipeState {}

final class AiRecipeInitial extends AiRecipeState {}

final class AiRecipeLoading extends AiRecipeState {}

final class AiRecipeLoaded extends AiRecipeState {
  final List<RecipeSuggestion> recipes;
  AiRecipeLoaded(this.recipes);
}

final class AiRecipeError extends AiRecipeState {
  final String message;
  AiRecipeError(this.message);
}
