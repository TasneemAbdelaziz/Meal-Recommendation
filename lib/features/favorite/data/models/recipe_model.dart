import 'package:recipe_app_withai/features/favorite/domain/entity/recipe_entity.dart';

class RecipeModel extends RecipeEntity {
  RecipeModel(
      {required super.id,
      required super.name,
      required super.image,
      required super.numberOfIngredients,
      required super.cookingTime,
      required super.category});

  // TODO : enable this code when implement Data Source
  // factory RecipeModel.fromMap(Map<String, dynamic> map) {
  //   return RecipeModel(
  //     id: id,
  //     name: name,
  //     image: image,
  //     numberOfIngredients: numberOfIngredients,
  //     cookingTime: cookingTime,
  //     category: category
  //   );
  // }
}
