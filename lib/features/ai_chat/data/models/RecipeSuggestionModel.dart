//
// class RecipeSuggestionModel extends RecipeSuggestion {
//   const RecipeSuggestionModel({
//     required super.id,
//     required super.title,
//     required super.imageUrl,
//   });
//
//   // Spoonacular: complexSearch / findByIngredients
//   factory RecipeSuggestionModel.fromJson(Map<String, dynamic> json) {
//     return RecipeSuggestionModel(
//       id: (json['id'] as num).toString(), // لو Entity عندك String
//       // لو حولتي id لـ int: id: (json['id'] as num).toInt(),
//       title: (json['title'] ?? '').toString(),
//       imageUrl: (json['image'] ?? '').toString(),
//     );
//   }
// }
