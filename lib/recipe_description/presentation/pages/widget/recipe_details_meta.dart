import 'package:flutter/material.dart';

class RecipeDetailsMeta extends StatelessWidget {
  final String categoryOrType;
  final int durationMinutes;
  final int servings;

  const RecipeDetailsMeta({
    Key? key,
    required this.categoryOrType,
    required this.durationMinutes,
    required this.servings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(categoryOrType, style: const TextStyle(color: Colors.grey)),
        const SizedBox(width: 8),
        const Text('•', style: TextStyle(color: Colors.grey)),
        const SizedBox(width: 8),
        const Icon(Icons.access_time, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text('$durationMinutes min', style: const TextStyle(color: Colors.grey)),
        const SizedBox(width: 8),
        const Text('•', style: TextStyle(color: Colors.grey)),
        const SizedBox(width: 8),
        const Icon(Icons.people, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text('$servings Servings', style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
