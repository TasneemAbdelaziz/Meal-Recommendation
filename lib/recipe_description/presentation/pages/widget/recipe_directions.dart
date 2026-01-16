import 'package:flutter/material.dart';

class RecipeDirections extends StatelessWidget {
  final List<String> directions;

  const RecipeDirections({Key? key, required this.directions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: directions.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            radius: 12,
            backgroundColor: Colors.black,
            child: Text('${index + 1}', style: const TextStyle(color: Colors.white, fontSize: 12)),
          ),
          title: Text(directions[index]),
        );
      },
    );
  }
}
