import 'package:flutter/material.dart';

class RecipeSummary extends StatelessWidget {
  final String description;

  const RecipeSummary({Key? key, required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Text(
        description,
        style: const TextStyle(fontSize: 16, height: 1.5),
      ),
    );
  }
}
