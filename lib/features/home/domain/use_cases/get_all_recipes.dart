// features/home/domain/usecases/get_all_recipes.dart
import 'package:fpdart/fpdart.dart';
import 'package:recipe_app_withai/core/errors/failure.dart';
import 'package:recipe_app_withai/core/usecase/usecase.dart';
import 'package:recipe_app_withai/features/home/domain/entities/recipe_entity.dart';
import 'package:recipe_app_withai/features/home/domain/repositories/home_repository.dart';

class GetAllRecipes implements UseCase<List<RecipeEntity>, NoParams> {
  final HomeRepository repository;

  GetAllRecipes(this.repository);

  @override
  Future<Either<Failure, List<RecipeEntity>>> call(NoParams params) async {
    try {
      final recipes = await repository.getAllRecipes();
      return Right(recipes);
    } catch (e) {
      return Left(ServerFailure('Failed to get recipes: $e'));
    }
  }
}