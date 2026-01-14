import '../../domain/entities/recipe_details_request.dart';
import '../models/recipe_details_model.dart';

abstract class RecipeDetailsRemoteDataSource {
  Future<RecipeDetailsModel> getDetails(RecipeDetailsRequest req);
}
