import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_pallet.dart';
import '../Widgets/IngredientInputField.dart';
import '../Widgets/meal_details.dart';
import '../cubit/suggested_recipe_cubit.dart';
import '../cubit/suggested_recipe_state.dart';


class MealSuggestionScreen extends StatelessWidget {
  final TextEditingController ingredientController = TextEditingController();

  MealSuggestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IngredientInputField(
              controller: ingredientController,

              onGetSuggestionPressed: () {
                final ingredients = ingredientController.text.trim();
                if (ingredients.isNotEmpty) {
                  context
                      .read<SuggestedRecipeCubit>()
                      .fetchSuggestedRecipe(ingredients);
                }
              },
            ),
            SizedBox(height: screenHeight * 0.02),
            BlocBuilder<SuggestedRecipeCubit, SuggestedRecipeState>(
              builder: (context, state) {
                if (state is SuggestedRecipeLoading) {
                  return Center(
                    child: SizedBox(
                      height: screenHeight * 0.05,
                      width: screenHeight * 0.05,
                      child: const CircularProgressIndicator(),
                    ),
                  );
                } else if (state is SuggestedRecipeSuccess) {
                  return RecipeDetails(state: state);
                } else if (state is SuggestedRecipeError) {
                  return ErrorMessage(
                    message: state.errorMessage,
                    textSize: screenWidth * 0.04,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        'Recipe Suggestion',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color:AppPallet.mainColor
        ),
      ),
      foregroundColor: AppPallet.mainColor,
    );
    // );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final double fontSize;

  const SectionHeader({required this.title, this.fontSize = 20, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: AppPallet.mainColor,
      ),
    );
  }
}

class ErrorMessage extends StatelessWidget {
  final String message;
  final double textSize;

  const ErrorMessage(
      {required this.message, required this.textSize, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Error: $message',
        style: TextStyle(
          color: Colors.red,
          fontSize: textSize,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}