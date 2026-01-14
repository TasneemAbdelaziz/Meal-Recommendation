import 'package:flutter/material.dart';

class RecipeDetailsImage extends StatelessWidget {
  final String imageUrl;

  const RecipeDetailsImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          imageUrl,
          height: 250,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              Container(height: 250, color: Colors.grey, child: const Icon(Icons.broken_image)),
        ),
      ],
    );
  }
}
