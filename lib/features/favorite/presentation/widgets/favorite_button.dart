import 'package:flutter/material.dart';
import 'package:recipe_app_withai/core/theme/app_pallet.dart';

class FavoriteButton extends StatelessWidget{
  bool isFavorite;
   FavoriteButton({required this.isFavorite,super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(
      isFavorite ? Icons.favorite : Icons.favorite_border,
      size: 26,
      color: AppPallet.mainColor,
    );
  }
}
