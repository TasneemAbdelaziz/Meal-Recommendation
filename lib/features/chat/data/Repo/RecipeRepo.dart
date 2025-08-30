import '../data_source/suggested_Meals.dart';
import '../models/ImageModel.dart';
import '../models/suggestedMealModel.dart';

class RecipeRepository {
  final RecipeRemoteDatasource remoteDatasource;
  RecipeRepository(this.remoteDatasource);

  Future<AIMeal> getRecipeSuggestions(String ingredients) async {
    final result = await remoteDatasource.getRecipeSuggestions(ingredients);
    return AIMeal(
        name: result.name,
        mealType: result.mealType,
        rating: result.rating,
        cookTime: result.cookTime,
        servingSize: result.servingSize,
        summary: result.summary,
        ingredients: result.ingredients,
        mealSteps: result.mealSteps, ps: []);
  }

  Future<ImageModel> getDishImage(String dishName)async {
    final result=await remoteDatasource.getDishImage(dishName);
    return result;
  }

}