import 'package:recipe_app_withai/features/home/domian/entities/recipe_entity.dart';

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
      'ingredientes':ingredients
    };
  }

  factory RecipeModel.fromJson(Map<String,dynamic> map){
    return RecipeModel(
        id:map['id']as String,
        posterId:map['poster_id']as String,
        title:map['title']as String,
        imagePath:map['main_image_url']as String,
        durationMinutes:map['description']as int,
        category:map['category']as String,
        isFavorite:map['is_favorite']as bool,
        updatedAt:map['updated_at']==null?DateTime.now():DateTime.parse(map['updated_at']),
        ingredients:List<String>.from(map['ingredientes'] ?? []),
        description:map['description']
    );
  }

  RecipeModel copyWith({
    String? id,
    String? posterId,
    String? title,
    String? category,
    // final int ingredientsCount;
    String? description,
    List<String>? ingredients,
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

