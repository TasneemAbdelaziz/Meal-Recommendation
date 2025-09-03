import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:recipe_app_withai/features/add_recipe/domian/entities/ingredient.dart';
import 'package:recipe_app_withai/features/add_recipe/domian/use_cases/add_recipe_usecase.dart';
part 'recipe_event.dart';
part 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final UploadRecipe uploadRecipe;
  RecipeBloc(this.uploadRecipe) : super(RecipeInitial()) {
    on<RecipeEvent>((event, emit) => emit(RecipeLoading()));
    on<RecipeUpload>(_onRecipeUpload);
  }
  void _onRecipeUpload(RecipeUpload event, Emitter<RecipeState> emit) async {
    final res = await uploadRecipe(UploadRecipeParams(
        posterId: event.posterId,
        title: event.title,
        category: event.category,
        description: event.description,
        ingredients: event.ingredients,
        durationMinutes: event.durationMinutes,
        image: event.image,
        isFavorite: event.isFavorite
        // event.updatedAt,
        ));
    return res.fold(
        (l) => emit(RecipeFailure(l.message)), (r) => emit(RecipeSuccess()));
  }
}
