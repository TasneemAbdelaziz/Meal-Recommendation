import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StarsIcons extends StatelessWidget {
  var rating;
   StarsIcons({required this.rating,super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (i) {
        final filled = i < rating;
        return Icon(
          filled ? Icons.star_rounded : Icons.star_border_rounded,
          size: 20,
          color: const Color(0xFFF5B301),
        );
      }),
    );
  }
}
