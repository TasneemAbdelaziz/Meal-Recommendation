import 'package:fpdart/fpdart.dart';
import 'package:recipe_app_withai/core/errors/failure.dart';
import 'package:recipe_app_withai/core/usecase/usecase.dart';

import '../entities/recipe_entity.dart';
import '../repositories/recipe_repository.dart';

class GetRecipes implements UseCase<List<RecipeEntity>, NoParams> {
  final RecipeRepository repository;

  GetRecipes(this.repository);

  @override
  Future<Either<Failure, List<RecipeEntity>>> call(NoParams params) async {
    return await repository.getRecipes();
  }
}
