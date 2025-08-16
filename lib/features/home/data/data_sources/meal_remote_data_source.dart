import 'dart:io';

import 'package:recipe_app_withai/core/data/recipe_model.dart';
import 'package:recipe_app_withai/core/entity/recipe_entity.dart';
import 'package:recipe_app_withai/core/errors/failure.dart';
import 'package:recipe_app_withai/features/home/data/models/recipe_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class RecipeRemoteDataSource{
  Future<RecipeModel> uploadMeal(RecipeModel recipe);
  Future<String> uploadMealImage(
  {required File image,
    required RecipeModel recipe});
}

class RecipeRemoteDataSourceImpl implements RecipeRemoteDataSource{
  final SupabaseClient supabaseClient;
  RecipeRemoteDataSourceImpl(this.supabaseClient);
  @override
  Future<RecipeModel> uploadMeal(RecipeModel recipe) async{
    try{
      final mealData = await supabaseClient.from('meals').insert(recipe.toJson()).select();
      return RecipeModel.fromJson(mealData.first);
    }catch (e){
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<String> uploadMealImage({required File image, required RecipeModel recipe}) async{
   try{
     await supabaseClient.storage.from('meals_images').upload(recipe.id, image);
     return supabaseClient.storage.from('meals_images').getPublicUrl(recipe.id);
   }catch(e){
     throw ServerFailure(e.toString());
   }
  }
  
}