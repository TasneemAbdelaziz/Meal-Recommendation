import 'package:flutter/material.dart';
import 'package:recipe_app_withai/core/theme/app_pallet.dart';
import 'package:recipe_app_withai/features/favorite/presentation/widgets/favorite_button.dart';
import 'package:recipe_app_withai/features/favorite/presentation/widgets/stars_icons.dart';

class MealCard extends StatelessWidget {
  const MealCard({
    super.key,
    required this.imageUrl,
    required this.tag, // vegan
    required this.title, // italian pizza
    required this.ingredientsCount, // 12
    required this.timeText, // 30min
    required this.rating, // 0..5
    required this.isFavorite,
    required this.onFavoriteTap,
  });

  final String imageUrl;
  final String tag;
  final String title;
  final int ingredientsCount;
  final String timeText;
  final int rating;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    const borderRadius = 14.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Circular image
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: Image.network(
                imageUrl,
                width: 78,
                height: 78,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 14),

            // Texts + stars
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tag,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF243B63),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0E1B2A),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ingredients + time
                  Row(
                    children: [
                      Text(
                        "$ingredientsCount ingrediantes",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        "$timeText min",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF243B63),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // rating stars
                  StarsIcons(rating: rating),
                ],
              ),
            ),

            // Favorite icon
            InkWell(
              onTap: onFavoriteTap,
              borderRadius: BorderRadius.circular(999),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: FavoriteButton(isFavorite: isFavorite),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
