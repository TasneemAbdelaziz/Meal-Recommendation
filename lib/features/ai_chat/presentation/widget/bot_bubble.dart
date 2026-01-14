
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BotBubble extends StatelessWidget {
  final Widget child;
  const BotBubble({required this.child});

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).brightness == Brightness.dark
        ? Colors.white10
        : Colors.grey.shade200;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 340),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: child,
      ),
    );
  }
}