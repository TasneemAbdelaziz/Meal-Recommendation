import 'package:fpdart/fpdart.dart';
import 'package:recipe_app_withai/core/errors/failure.dart';
import 'package:recipe_app_withai/features/ai_chat/data/datasources/gemini_remote_data_source.dart';
import 'package:recipe_app_withai/features/ai_chat/data/datasources/spoonacular_remote_data_source.dart';
import 'package:recipe_app_withai/features/ai_chat/domain/entities/ai_query.dart';
import 'package:recipe_app_withai/features/ai_chat/domain/entities/recipe_suggestion.dart';
import 'package:recipe_app_withai/features/ai_chat/domain/repositories/ai_recipe_repository.dart';

class AiRecipeRepositoryImpl implements AiRecipeRepository {
  final GeminiRemoteDataSource geminiRemoteDataSource;
  final SpoonacularRemoteDataSource spoonacularRemoteDataSource;

  AiRecipeRepositoryImpl({
    required this.geminiRemoteDataSource,
    required this.spoonacularRemoteDataSource,
  });

  @override
  Future<Either<Failure, AiQuery>> parseUserQuery(String userText) async {
    try {
      final result = await geminiRemoteDataSource.parseUserQuery(userText);
      return Right(result);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RecipeSuggestion>>> searchRecipes(AiQuery query) async {
    try {
      final result = await spoonacularRemoteDataSource.searchRecipes(query);
      return Right(result);
    } catch (e) {
       if (e is Failure) return Left(e);
      return Left(ServerFailure(e.toString()));
    }
  }
}
