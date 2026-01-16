import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserBubble extends StatelessWidget {
  final String text;
  const UserBubble({required this.text});

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).primaryColor;

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}