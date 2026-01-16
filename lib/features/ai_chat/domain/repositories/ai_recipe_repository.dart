import 'package:fpdart/fpdart.dart';
import 'package:recipe_app_withai/core/errors/failure.dart';
import 'package:recipe_app_withai/features/ai_chat/domain/entities/ai_query.dart';
import 'package:recipe_app_withai/features/ai_chat/domain/entities/recipe_suggestion.dart';

abstract interface class AiRecipeRepository {
  Future<Either<Failure, AiQuery>> parseUserQuery(String userText);
  Future<Either<Failure, List<RecipeSuggestion>>> searchRecipes(AiQuery query);
}
