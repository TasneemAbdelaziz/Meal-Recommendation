import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app_withai/features/ai_chat/domain/entities/recipe_suggestion.dart';
import 'package:recipe_app_withai/features/ai_chat/domain/usecases/parse_user_query_usecase.dart';
import 'package:recipe_app_withai/features/ai_chat/domain/usecases/search_recipes_usecase.dart';
part 'ai_recipe_event.dart';
part 'ai_recipe_state.dart';

class AiRecipeBloc extends Bloc<AiRecipeEvent, AiRecipeState> {
  final ParseUserQueryUseCase _parseUserQueryUseCase;
  final SearchRecipesUseCase _searchRecipesUseCase;

  AiRecipeBloc({
    required ParseUserQueryUseCase parseUserQueryUseCase,
    required SearchRecipesUseCase searchRecipesUseCase,
  })  : _parseUserQueryUseCase = parseUserQueryUseCase,
        _searchRecipesUseCase = searchRecipesUseCase,
        super(AiRecipeInitial()) {
    on<AiRecipeExtractAndSearch>(_onExtractAndSearch);
  }

  Future<void> _onExtractAndSearch(
    AiRecipeExtractAndSearch event,
    Emitter<AiRecipeState> emit,
  ) async {
    emit(AiRecipeLoading());

    final extractResult = await _parseUserQueryUseCase(event.userQuery);

    await extractResult.fold(
      (failure) async => emit(AiRecipeError(failure.message)),
      (aiQuery) async {
        final searchResult = await _searchRecipesUseCase(aiQuery);
        searchResult.fold(
          (failure) => emit(AiRecipeError(failure.message)),
          (recipes) {
            if (recipes.isEmpty) {
              emit(AiRecipeError("No recipes found"));
            } else {
              emit(AiRecipeLoaded(recipes));
            }
          },
        );
      },
    );
  }
}
