import 'package:equatable/equatable.dart';

class RecipeIngredientEntity extends Equatable {
  final String name;
  final String? imageUrl;

  const RecipeIngredientEntity({
    required this.name,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [name, imageUrl];
}
