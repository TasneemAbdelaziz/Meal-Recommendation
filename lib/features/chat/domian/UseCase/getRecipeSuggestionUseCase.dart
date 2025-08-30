import '../../Data/Repo/recipeRepo.dart';
import '../../Data/models/ImageModel.dart';
import '../../Data/models/suggestedMealModel.dart';

class GetRecipeSuggestionUseCase {
  final RecipeRepository recipeRepository;

  GetRecipeSuggestionUseCase(this.recipeRepository);

  Future<AIMeal> call(String ingredients) {
    return recipeRepository.getRecipeSuggestions(ingredients);
  }

  Future<ImageModel> callGetImage(String dishName) {
    return recipeRepository.getDishImage(dishName);
  }
}