import 'package:flutter/material.dart';
import '../Screens/GeminiAiScreen.dart';
import '../cubit/suggested_recipe_state.dart';
import 'card_content.dart';
import 'ingredientList.dart';
import 'instructionList.dart';
import 'package:recipe_app_withai/features/chat/Data/models/suggestedMealModel.dart';

class RecipeDetails extends StatelessWidget {
  final SuggestedRecipeSuccess state;

  const RecipeDetails({required this.state, super.key});

  @override
  Widget build(BuildContext context) {
    final recipe = state.suggestedRecipe;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 20),
      const SectionHeader(title: 'Meal Name'),
      CardContent(content: recipe.name),
      const SizedBox(height: 10),
      const SectionHeader(title: 'Description'),
      CardContent(content: recipe.summary),
      const SizedBox(height: 10),
      const SectionHeader(title: 'Ingredients'),
      IngredientList(ingredients: recipe.ingredients),
      const SizedBox(height: 10),
      const SectionHeader(title: 'Instructions'),
      InstructionList(instructions: recipe.mealSteps),
    ]);
  }
}