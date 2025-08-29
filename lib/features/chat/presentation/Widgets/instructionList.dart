import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InstructionList extends StatelessWidget {
  final List<String> instructions;

  const InstructionList({required this.instructions, super.key});

  @override
  Widget build(BuildContext context) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: instructions.asMap().entries.map((entry) {
          final index = entry.key + 1;
          final instruction = entry.value;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$index. ',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Expanded(child: Text(instruction)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            offset: const Offset(0, 2),
            blurRadius: 5,
          ),
        ],
      ),
      child: child,
    );
  }
}