import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/recipe_details_request.dart';
import '../models/recipe_details_model.dart';
import 'recipe_details_remote_datasource.dart';
import '../../../../core/secrets/app_secrets.dart';

class SpoonacularRecipeDetailsDataSource implements RecipeDetailsRemoteDataSource {
  final http.Client client;

  SpoonacularRecipeDetailsDataSource(this.client);

  @override
  Future<RecipeDetailsModel> getDetails(RecipeDetailsRequest req) async {
    final apiKey = AppSecrets.spoonacularApiKey;
    final url = Uri.parse('https://api.spoonacular.com/recipes/${req.id}/information?apiKey=$apiKey&includeNutrition=false');
    
    final response = await client.get(url);

    if (response.statusCode == 200) {
      return RecipeDetailsModel.fromSpoonacular(json.decode(response.body));
    } else {
      throw Exception('Failed to load Spoonacular recipe: ${response.statusCode}');
    }
  }
}
