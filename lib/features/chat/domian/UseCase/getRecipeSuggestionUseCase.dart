import '../../data/Repo/RecipeRepo.dart';
import '../../data/models/ImageModel.dart';
import '../../data/models/suggestedMealModel.dart';

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