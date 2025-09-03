class AIMeal {
  final String name;
  final String mealType;
  final double rating;
  final int cookTime;
  final int servingSize;
  final String summary;
  final List<Ingredient> ingredients;
  final List<String> mealSteps;

  AIMeal({
    required this.name,
    required this.mealType,
    required this.rating,
    required this.cookTime,
    required this.servingSize,
    required this.summary,
    required this.ingredients,
    required this.mealSteps,
    required List<String> ps,
  });

  factory AIMeal.fromJson(Map<String, dynamic> json) {
    return AIMeal(
      name: json['name'] as String,
      mealType: json['meal_type'] as String,
      rating: (json['rating'] as num).toDouble(),
      cookTime: json['cook_time'] as int,
      servingSize: json['serving_size'] as int,
      summary: json['summary'] as String,
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((ingredient) => Ingredient.fromJson(ingredient))
          .toList(),
      mealSteps: List<String>.from(json['meal_steps'] as List), ps: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'meal_type': mealType,
      'rating': rating,
      'cook_time': cookTime,
      'serving_size': servingSize,
      'summary': summary,
      'ingredients': ingredients.map((ingredient) => ingredient.toJson()).toList(),
      'meal_steps': mealSteps,
    };
  }
}

class Ingredient {
  final String name;
  final String imageUrl;
  final String quantity;

  Ingredient({
    required this.name,
    required this.imageUrl,
    required this.quantity,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'] as String,
      imageUrl: json['image_url'] as String,
      quantity: json['quantity'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image_url': imageUrl,
      'quantity': quantity,
    };
  }
}
