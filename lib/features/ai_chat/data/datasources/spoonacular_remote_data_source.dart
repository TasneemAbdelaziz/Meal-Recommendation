import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recipe_app_withai/core/errors/failure.dart';
import 'package:recipe_app_withai/core/secrets/app_secrets.dart';
import 'package:recipe_app_withai/features/ai_chat/data/models/recipe_suggestion_model.dart';
import 'package:recipe_app_withai/features/ai_chat/domain/entities/ai_query.dart';

abstract interface class SpoonacularRemoteDataSource {
  Future<List<RecipeSuggestionModel>> searchRecipes(AiQuery query);
}

class SpoonacularRemoteDataSourceImpl implements SpoonacularRemoteDataSource {
  final http.Client client;

  SpoonacularRemoteDataSourceImpl(this.client);

  @override
  Future<List<RecipeSuggestionModel>> searchRecipes(AiQuery query) async {
    const apiKey = AppSecrets.spoonacularApiKey;
    Uri url;

    if (query.mode == 'byIngredients' && query.ingredients.isNotEmpty) {
      // Find by ingredients
      final ingredientsStr = query.ingredients.join(',');
      url = Uri.parse(
          'https://api.spoonacular.com/recipes/findByIngredients?apiKey=$apiKey&ingredients=$ingredientsStr&number=10');
    } else {
      // Search by name (complexSearch)
      // Use query.query or 'recipe' fallback
      final q = query.query ?? (query.ingredients.isNotEmpty ? query.ingredients.join(' ') : 'recipe');
      
      final buffer = StringBuffer('https://api.spoonacular.com/recipes/complexSearch?apiKey=$apiKey&query=$q&number=10');
      if (query.maxReadyTime != null) {
        buffer.write('&maxReadyTime=${query.maxReadyTime}');
      }
      if (query.cuisine != null) {
        buffer.write('&cuisine=${query.cuisine}');
      }
      url = Uri.parse(buffer.toString());
    }

    try {
      final response = await client.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        List<dynamic> results;
        if (query.mode == 'byIngredients' && query.ingredients.isNotEmpty) {
          // findByIngredients returns a list directly
          results = data as List<dynamic>;
          return results.map((e) => RecipeSuggestionModel.fromIngredientsJson(e)).toList();
        } else {
          // complexSearch returns { "results": [...] }
          results = data['results'] as List<dynamic>;
          return results.map((e) => RecipeSuggestionModel.fromJson(e)).toList();
        }
      } else {
         throw ServerFailure('Spoonacular API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      if (e is ServerFailure) rethrow;
      throw ServerFailure(e.toString());
    }
  }
}
