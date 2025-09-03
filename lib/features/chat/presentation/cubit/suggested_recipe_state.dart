import '../../Data/models/ImageModel.dart';
import '../../Data/models/suggestedMealModel.dart';

abstract class SuggestedRecipeState {}

class SuggestedRecipeInitial extends SuggestedRecipeState {}

class SuggestedRecipeSuccess extends SuggestedRecipeState {
  final AIMeal suggestedRecipe;
  final ImageModel dishImage;
  SuggestedRecipeSuccess(this.suggestedRecipe,this.dishImage);
}

class SuggestedRecipeLoading extends SuggestedRecipeState {}

class SuggestedRecipeError extends SuggestedRecipeState {
  final String errorMessage;

  SuggestedRecipeError({required this.errorMessage});
}