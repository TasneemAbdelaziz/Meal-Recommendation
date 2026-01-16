import 'package:fpdart/fpdart.dart';
import 'package:recipe_app_withai/core/errors/failure.dart';
import 'package:recipe_app_withai/core/usecase/usecase.dart';
import 'package:recipe_app_withai/features/ai_chat/domain/entities/ai_query.dart';
import 'package:recipe_app_withai/features/ai_chat/domain/repositories/ai_recipe_repository.dart';

class ParseUserQueryUseCase implements UseCase<AiQuery, String> {
  final AiRecipeRepository repository;

  ParseUserQueryUseCase(this.repository);

  @override
  Future<Either<Failure, AiQuery>> call(String params) async {
    return await repository.parseUserQuery(params);
  }
}
