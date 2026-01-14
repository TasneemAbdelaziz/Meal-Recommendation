import 'package:equatable/equatable.dart';
import 'recipe_ingredient_entity.dart';

class RecipeDetailsEntity extends Equatable {
  final String id;
  final String title;
  final String categoryOrType;
  final String description;
  final int durationMinutes;
  final int servings;
  final String imageUrl;
  final List<RecipeIngredientEntity> ingredients;
  final List<String> directions;

  const RecipeDetailsEntity({
    required this.id,
    required this.title,
    required this.categoryOrType,
    required this.description,
    required this.durationMinutes,
    required this.servings,
    required this.imageUrl,
    required this.ingredients,
    required this.directions,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        categoryOrType,
        description,
        durationMinutes,
        servings,
        imageUrl,
        ingredients,
        directions,
      ];
}
