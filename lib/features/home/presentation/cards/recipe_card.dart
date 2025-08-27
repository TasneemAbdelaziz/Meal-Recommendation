import 'dart:io';
import 'package:flutter/material.dart';
import 'package:recipe_app_withai/features/home/domain/recipe_entity.dart';

class RecipeCard extends StatelessWidget {
  final RecipeEntity recipe;
  final VoidCallback? onFavoriteToggle;

  const RecipeCard({
    super.key,
    required this.recipe,
    this.onFavoriteToggle,
  });

  Widget _buildImage() {
    if (recipe.imagePath == null) {
      return const Icon(Icons.fastfood, size: 40);
    }
    
    // Check if it's a network URL or local file path
    if (recipe.imagePath!.startsWith('http://') || recipe.imagePath!.startsWith('https://')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.network(
          recipe.imagePath!,
          fit: BoxFit.cover,
          width: 50,
          height: 50,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.fastfood, size: 40);
          },
        ),
      );
    } else {
      // Local file path
      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.file(
          File(recipe.imagePath!),
          fit: BoxFit.cover,
          width: 50,
          height: 50,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.fastfood, size: 40);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: _buildImage(),
        title: Text(recipe.title),
        subtitle: Text(
          "${recipe.category} • ${recipe.ingredientsCount} ingredients",
        ),
        trailing: IconButton(
          icon: Icon(
            recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: Colors.red,
          ),
          onPressed: onFavoriteToggle,
        ),
      ),
    );
  }
}

