

import 'package:recipe_app_withai/features/add_recipe/domian/entities/ingredient.dart';
import 'package:recipe_app_withai/features/add_recipe/domian/entities/recipe_entity.dart';

class RecipeModel extends RecipeEntity {
  RecipeModel({
    required super.id,
    required super.category,
    required super.description,
    required super.durationMinutes,
    required super.imagePath,
    required super.ingredients,
    required super.isFavorite,
    required super.posterId,
    required super.title,
    required super.updatedAt,
  });


  Map<String,dynamic> toJson(){
    final ingredientsJson = ingredients.map((ingredient) => {
      'name': ingredient.name,
      'image_url': ingredient.imagePath,
    }).toList();
    return <String,dynamic>{
      'id':id,
      'updated_at':updatedAt.toIso8601String(),
      'poster_id':posterId,
      'is_favorite':isFavorite,
      'title':title,
      'category':category,
      'description':description,
      'main_image_url':imagePath,
      'duration':durationMinutes,
      'ingredientes':ingredientsJson
    };
  }

  factory RecipeModel.fromJson(Map<String, dynamic> map) {
    List<Ingredient> ingredientsList = [];

    if (map['ingredientes'] != null && map['ingredientes'] is List) {
      final ingredientsData = map['ingredientes'] as List;

      ingredientsList = ingredientsData.map((item) {
        if (item is Map<String, dynamic>) {
          return Ingredient(
            name: item['name']?.toString() ?? '',
            imagePath: item['image_url']?.toString(),
          );
        } else if (item is String) {
          // للتوافق مع الإصدارات القديمة التي كانت تخزن المكونات كنصوص فقط
          return Ingredient(name: item);
        } else {
          return Ingredient(name: '');
        }
      }).toList();
    }
    return RecipeModel(
        id:map['id']as String,
        posterId:map['poster_id']as String,
        title:map['title']as String,
        imagePath:map['main_image_url']as String,
        durationMinutes:(map['duration'] ?? 0) as int,
        category:map['category']as String,
        isFavorite:map['is_favorite']as bool,
        updatedAt:map['updated_at']==null?DateTime.now():DateTime.parse(map['updated_at']),
        ingredients:ingredientsList,
        description:map['description']
    );
  }

  RecipeModel copyWith({
    String? id,
    String? posterId,
    String? title,
    String? category,
    String? description,
    List<Ingredient>? ingredients,
    int? durationMinutes,
    String? imagePath,
    bool? isFavorite,
    DateTime? updatedAt,
  }) {
    return RecipeModel(
      id: id ?? this.id,
      posterId: posterId ?? this.posterId,
      title: title ?? this.title,
      category: category ?? this.category,
      description: description ?? this.description,
      ingredients: ingredients ?? this.ingredients,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      imagePath: imagePath ?? this.imagePath,
      isFavorite: isFavorite ?? this.isFavorite,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
