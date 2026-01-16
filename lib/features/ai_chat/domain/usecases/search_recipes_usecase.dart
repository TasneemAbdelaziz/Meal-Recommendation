import 'package:fpdart/fpdart.dart';
import 'package:recipe_app_withai/core/errors/failure.dart';
import 'package:recipe_app_withai/core/usecase/usecase.dart';
import 'package:recipe_app_withai/features/ai_chat/domain/entities/ai_query.dart';
import 'package:recipe_app_withai/features/ai_chat/domain/entities/recipe_suggestion.dart';
import 'package:recipe_app_withai/features/ai_chat/domain/repositories/ai_recipe_repository.dart';

class SearchRecipesUseCase implements UseCase<List<RecipeSuggestion>, AiQuery> {
  final AiRecipeRepository repository;

  SearchRecipesUseCase(this.repository);

  @override
  Future<Either<Failure, List<RecipeSuggestion>>> call(AiQuery params) async {
    return await repository.searchRecipes(params);
  }
}
