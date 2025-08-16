import 'dart:io';

import 'package:fpdart/src/either.dart';
import 'package:recipe_app_withai/core/errors/failure.dart';
import 'package:recipe_app_withai/core/usecase/usecase.dart';

import '../entities/recipe_entity.dart';
import '../repositories/recipe_repository.dart';
class UploadRecipe implements UseCase<RecipeEntity, UploadRecipeParams> {
  final RecipeRepository repository;

  UploadRecipe(this.repository);

  @override
  Future<Either<Failure, RecipeEntity>> call(UploadRecipeParams params) async {
    return await repository.uploadRecipe(
      title: params.title,
      category: params.category,
      description: params.description,
      ingredients: params.ingredients,
      durationMinutes: params.durationMinutes,
      image: params.image,
      isFavorite: params.isFavorite,
      posterId: params.posterId,
    );
  }
}

class UploadRecipeParams {
  final String posterId;
  final String title;
  final String category;
  final String description;
  final List<String> ingredients;
  final int durationMinutes;
  final File image;
  final bool isFavorite;
  // final DateTime updatedAt;

  UploadRecipeParams(
      this.posterId,
      this.title,
      this.category,
      this.description,
      this.ingredients,
      this.durationMinutes,
      this.image,
      this.isFavorite,
      // this.updatedAt
      );
}
