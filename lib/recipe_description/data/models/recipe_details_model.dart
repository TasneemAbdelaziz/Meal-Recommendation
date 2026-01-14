import '../../domain/entities/recipe_details_entity.dart';
import '../../domain/entities/recipe_ingredient_entity.dart';
import 'recipe_ingredient_model.dart';

class RecipeDetailsModel extends RecipeDetailsEntity {
  const RecipeDetailsModel({
    required super.id,
    required super.title,
    required super.categoryOrType,
    required super.description,
    required super.durationMinutes,
    required super.servings,
    required super.imageUrl,
    required super.ingredients,
    required super.directions,
  });

  factory RecipeDetailsModel.fromSupabase(Map<String, dynamic> json) {
    // Supabase ingredients input is List<dynamic> (jsonb)
    // Structure: [{ "name": "...", "image_url": "..." }]
    var rawIngredients = json['ingredientes'] as List<dynamic>? ?? [];
    List<RecipeIngredientEntity> mappedIngredients = rawIngredients.map((e) {
      return RecipeIngredientModel.fromJson(e as Map<String, dynamic>);
    }).toList();

    // Supabase description is text
    // Directions might not be in DB, using empty list or parsing a field if it exists
    // User said "For DB, directions may not exist (handle as empty list)."
    
    return RecipeDetailsModel(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      categoryOrType: json['category'] as String? ?? 'Meal',
      description: json['description'] as String? ?? '',
      durationMinutes: json['duration'] as int? ?? 0,
      servings: 1, // Default or adding column later if needed, user didn't specify servings column in Supabase table contract
      imageUrl: json['main_image_url'] as String? ?? '',
      ingredients: mappedIngredients,
      directions: [], // Empty as per requirement
    );
  }

  factory RecipeDetailsModel.fromSpoonacular(Map<String, dynamic> json) {
    // Spoonacular mapping
    // title -> title
    // imageUrl -> image
    // category/type -> dishTypes[0] or "meal"
    // duration -> readyInMinutes
    // servings -> servings
    // summary -> summary (HTML stripped)
    // ingredients -> extendedIngredients[*].name
    // directions -> analyzedInstructions[*].steps[*].step
    
    String stripHtml(String htmlString) {
      final RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
      return htmlString.replaceAll(exp, '');
    }

    String category = 'Meal';
    if (json['dishTypes'] != null && (json['dishTypes'] as List).isNotEmpty) {
      category = (json['dishTypes'] as List).first as String;
    }

    String summary = json['summary'] as String? ?? '';
    summary = stripHtml(summary);

    List<RecipeIngredientEntity> ingredients = [];
    if (json['extendedIngredients'] != null) {
      ingredients = (json['extendedIngredients'] as List).map((e) {
        return RecipeIngredientModel.fromSpoonacular(e as Map<String, dynamic>);
      }).toList();
    }

    List<String> directions = [];
    if (json['analyzedInstructions'] != null && (json['analyzedInstructions'] as List).isNotEmpty) {
       var firstInstruction = (json['analyzedInstructions'] as List).first;
       if (firstInstruction['steps'] != null) {
         directions = (firstInstruction['steps'] as List).map((step) {
           return step['step'] as String;
         }).toList();
       }
    }

    return RecipeDetailsModel(
      id: json['id'].toString(),
      title: json['title'] as String? ?? '',
      categoryOrType: category,
      description: summary,
      durationMinutes: json['readyInMinutes'] as int? ?? 0,
      servings: json['servings'] as int? ?? 1,
      imageUrl: json['image'] as String? ?? '',
      ingredients: ingredients,
      directions: directions,
    );
  }
}
