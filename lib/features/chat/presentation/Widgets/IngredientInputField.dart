import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_pallet.dart';

class IngredientInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onGetSuggestionPressed;

  const IngredientInputField({
    required this.controller,
    required this.onGetSuggestionPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          onSubmitted: (value) {

          },
          controller: controller,
          decoration: const InputDecoration(

            labelText: 'Enter ingredients',
            hintText: 'E.g., chicken, rice, tomato...',
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.food_bank),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onGetSuggestionPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppPallet.mainColor,
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: const Text(
              'Get Recipe Suggestion',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}