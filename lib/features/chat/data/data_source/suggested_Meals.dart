import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;

import '../models/ImageModel.dart';
import '../models/suggestedMealModel.dart';

class RecipeRemoteDatasource {
  final String apiKey = 'AIzaSyC7KGMLOwzuPM6hZXCz7QAnBXG5bqsUiII';
  final gemini = GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: 'AIzaSyC7KGMLOwzuPM6hZXCz7QAnBXG5bqsUiII',
  );

  String extractJson(String responseText) {
    final jsonStart = responseText.indexOf('{');
    final jsonEnd = responseText.lastIndexOf('}');
    if (jsonStart == -1 || jsonEnd == -1) {
      throw Exception('JSON data not found in the response');
    }
    return responseText.substring(jsonStart, jsonEnd + 1);
  }

  Future<AIMeal> getRecipeSuggestions(String ingredients) async {
    try {
      const prompt = '''
      I need a recipe suggestion for breakfast in JSON format that matches the structure of the model I provided below. The JSON should include the following sections: 
      - `name` (recipe name),
      - `meal_type` (type of meal),
      - `rating` (rating of the recipe),
      - `cook_time` (time to cook in minutes),
      - `serving_size` (number of servings),
      - `summary` (includes a description and a list of nutritional information),
      - `ingredients` (list of ingredients with names,image_url,and quantity in pieces),
      - `meal_steps` (list of cooking instructions).

      Return the response strictly in JSON format without any additional text or comments.
      Ensure the JSON response strictly adheres to the JSON standard:
- All keys and string values must be enclosed in double quotes.
- Fractions or mixed strings like `1/2` must be quoted as `"1/2"`.
      ''';

      final content = [Content.text(prompt)];

      final response = await gemini.generateContent(content);

      final jsonString = extractJson(response.text!.trim());
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      void printLongText(String text) {
        final pattern = RegExp('.{1,800}');
        for (final match in pattern.allMatches(text)) {
          print(match.group(0));
        }
      }

      printLongText(jsonString);
      return AIMeal.fromJson(jsonMap);
    } catch (e) {
      print('Error: $e');
      throw Exception('Error fetching recipe suggestions: $e');
    }
  }

  Future<ImageModel> getDishImage(String dishName) async {
    String baseUrl = 'https://api.spoonacular.com/recipes';
    String imageUrl = '/complexSearch';

    Uri url = Uri.https(baseUrl, imageUrl, {
      'apiKey': 'e2a21c9bc1754ab9bd830d5d65bf7a7d',
      'query': dishName,
      'addRecipeInformation': 'false',
    });
    try {
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      var json = jsonDecode(response.body);
      return ImageModel.fromJson(json);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}