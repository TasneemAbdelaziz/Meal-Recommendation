import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app_withai/features/chat/presentation/cubit/suggested_recipe_state.dart';
import '../../domian/UseCase/getRecipeSuggestionUseCase.dart';

class SuggestedRecipeCubit extends Cubit<SuggestedRecipeState> {
  final GetRecipeSuggestionUseCase getRecipeSuggestionUseCase;

  SuggestedRecipeCubit(this.getRecipeSuggestionUseCase) : super(SuggestedRecipeInitial());

  Future<void> fetchSuggestedRecipe(String ingredient) async {
    emit(SuggestedRecipeLoading());
    try {
      final recipe = await getRecipeSuggestionUseCase(ingredient);
      final image=await getRecipeSuggestionUseCase.callGetImage(recipe.name);
      emit(SuggestedRecipeSuccess(recipe,image));
    } catch (e) {
      emit(SuggestedRecipeError(errorMessage: e.toString()));
    }
  }
}