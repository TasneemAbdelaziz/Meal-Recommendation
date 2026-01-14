import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart'; 
import '../entities/recipe_details_entity.dart';
import '../entities/recipe_details_request.dart';

/// Abstract repository for fetching recipe details
abstract class RecipeDetailsRepository {
  Future<Either<Failure, RecipeDetailsEntity>> getDetails(RecipeDetailsRequest req);
}
