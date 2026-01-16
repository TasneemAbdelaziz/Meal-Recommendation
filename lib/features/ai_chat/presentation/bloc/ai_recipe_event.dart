part of 'ai_recipe_bloc.dart';

sealed class AiRecipeEvent {}

final class AiRecipeExtractAndSearch extends AiRecipeEvent {
  final String userQuery;
  AiRecipeExtractAndSearch(this.userQuery);
}
