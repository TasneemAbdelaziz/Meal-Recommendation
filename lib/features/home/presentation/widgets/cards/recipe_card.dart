import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe_app_withai/features/home/domian/entities/recipe_entity.dart';


class RecipeCard extends StatelessWidget {
  final RecipeEntity recipe;
  final VoidCallback? onFavoriteToggle;

  const RecipeCard({
    super.key,
    required this.recipe,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: recipe.imagePath != null
            ? ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.file(
            File(recipe.imagePath!),
            fit: BoxFit.cover,
            width: 50.w,
            height: 50.h,
          ),
        )
            : const Icon(Icons.fastfood, size: 40),
        title: Text(recipe.title),
        // subtitle: Text(
        //   "${recipe.category} • ${recipe.ingredientsCount} ingredients",
        // ),
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

