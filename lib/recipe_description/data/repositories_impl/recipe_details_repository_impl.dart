import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/recipe_details_entity.dart';
import '../../domain/entities/recipe_details_request.dart';
import '../../domain/repositories/recipe_details_repository.dart';
import '../datasources/supabase_recipe_details_datasource.dart';
import '../datasources/spoonacular_recipe_details_datasource.dart';

class RecipeDetailsRepositoryImpl implements RecipeDetailsRepository {
  final SupabaseRecipeDetailsDataSource supabaseDataSource;
  final SpoonacularRecipeDetailsDataSource spoonacularDataSource;

  RecipeDetailsRepositoryImpl({
    required this.supabaseDataSource,
    required this.spoonacularDataSource,
  });

  @override
  Future<Either<Failure, RecipeDetailsEntity>> getDetails(RecipeDetailsRequest req) async {
    try {
      if (req.source == RecipeSource.supabase) {
        final result = await supabaseDataSource.getDetails(req);
        return Right(result);
      } else {
        final result = await spoonacularDataSource.getDetails(req);
        return Right(result);
      }
    } catch (e) {
       // Convert exception to Failure
       // Assuming ServerFailure(e.toString())
       return Left(ServerFailure(e.toString())); 
    }
  }
}
