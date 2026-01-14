import 'package:equatable/equatable.dart';

enum RecipeSource { supabase, spoonacular }

class RecipeDetailsRequest extends Equatable {
  final RecipeSource source;
  final String id;

  const RecipeDetailsRequest({
    required this.source,
    required this.id,
  });

  @override
  List<Object?> get props => [source, id];
}
