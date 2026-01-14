import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app_withai/features/favorite/presentation/widgets/favorite_button.dart';
import 'package:recipe_app_withai/features/favorite/presentation/widgets/stars_icons.dart';
import 'package:recipe_app_withai/features/home/domain/entities/recipe_entity.dart';
import 'package:recipe_app_withai/features/favorite/presentation/bloc/favorites_bloc.dart';
import 'package:recipe_app_withai/features/favorite/presentation/bloc/favorites_event.dart';
import 'package:recipe_app_withai/features/favorite/presentation/bloc/favorites_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecipeCard extends StatelessWidget {
  final RecipeEntity recipe;

  const RecipeCard({
    super.key,
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    final recipeId = recipe.id;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Stack(
        children: [
          // ================= Image =================
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: recipe.imagePath != null && recipe.imagePath!.isNotEmpty
                ? Image.network(
              recipe.imagePath!,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _buildPlaceholder(),
            )
                : _buildPlaceholder(),
          ),

          // ================= Gradient Overlay =================
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),

          // ================= Favorite Button =================
          Positioned(
            top: 12,
            right: 12,
            child: BlocBuilder<FavoritesBloc, FavoritesState>(
              buildWhen: (p, c) => p.favoriteIds != c.favoriteIds,
              builder: (context, favState) {
                final isFav = favState.favoriteIds.contains(recipeId);

                return GestureDetector(
                  onTap: userId == null
                      ? null
                      : () {
                    context.read<FavoritesBloc>().add(
                      FavoriteToggled(
                        userId: userId,
                        recipeId: recipeId,
                      ),
                    );
                  },
                  child:FavoriteButton(isFavorite: isFav),
                );
              },
            ),
          ),

          // ================= Bottom Content (زي ما هو) =================
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recipe Title
                Text(
                  recipe.title ?? 'No Title',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),

                // Ingredients and Time
                Row(
                  children: [
                    Text(
                      '${recipe.ingredients.length} ingredients',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${recipe.durationMinutes ?? 0}min',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                StarsIcons(rating: recipe.durationMinutes),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 180,
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.food_bank, size: 50, color: Colors.grey),
      ),
    );
  }
}
