import 'package:recipe_app_withai/features/ai_chat/domain/entities/ai_query.dart';

class AiQueryModel extends AiQuery {
  const AiQueryModel({
    required super.mode,
    super.query,
    super.ingredients = const [],
    super.maxReadyTime,
    super.cuisine,
  });

  factory AiQueryModel.fromJson(Map<String, dynamic> json) {
    return AiQueryModel(
      mode: json['mode'] as String? ?? 'byName',
      query: json['query'] as String?,
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      maxReadyTime: json['maxReadyTime'] as int?,
      cuisine: json['cuisine'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mode': mode,
      'query': query,
      'ingredients': ingredients,
      'maxReadyTime': maxReadyTime,
      'cuisine': cuisine,
    };
  }
}
