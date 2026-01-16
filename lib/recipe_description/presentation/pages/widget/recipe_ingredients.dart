import 'package:flutter/material.dart';
import '../../../domain/entities/recipe_ingredient_entity.dart';

class RecipeIngredients extends StatelessWidget {
  final List<RecipeIngredientEntity> ingredients;

  const RecipeIngredients({Key? key, required this.ingredients}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: ingredients.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final ingredient = ingredients[index];
        return ListTile(
          leading: const Text('•', style: TextStyle(fontSize: 20)),
          title: Text(ingredient.name),
          trailing: ingredient.imageUrl != null
              ? Image.network(ingredient.imageUrl!, width: 40, height: 40, errorBuilder: (_,__,___)=>const SizedBox())
              : null,
        );
      },
    );
  }
}
