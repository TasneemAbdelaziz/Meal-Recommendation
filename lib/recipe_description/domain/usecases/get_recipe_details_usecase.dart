import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart'; 
import '../entities/recipe_details_entity.dart';
import '../entities/recipe_details_request.dart';
import '../repositories/recipe_details_repository.dart';

class GetRecipeDetailsUseCase implements UseCase<RecipeDetailsEntity, RecipeDetailsRequest> {
  final RecipeDetailsRepository repository;

  GetRecipeDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, RecipeDetailsEntity>> call(RecipeDetailsRequest params) async {
    return await repository.getDetails(params);
  }
}
