import 'package:flutter/material.dart';
import '../../../../core/theme/app_pallet.dart';

class IngredientList extends StatelessWidget {
  final List<dynamic> ingredients;

  const IngredientList({required this.ingredients, super.key});

  @override
  Widget build(BuildContext context) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: ingredients
            .map((ingredient) => ListTile(
            leading: Icon(Icons.check,
                size: 18, color: AppPallet.mainColor),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(ingredient.name),
              ],
            )))
            .toList(),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            offset: const Offset(0, 2),
            blurRadius: 5,
          ),
        ],
      ),
      child: child,
    );
  }
}