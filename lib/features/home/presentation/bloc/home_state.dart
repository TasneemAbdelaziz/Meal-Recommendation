import 'package:equatable/equatable.dart';
import 'package:recipe_app_withai/features/home/domain/recipe_entity.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<RecipeEntity> recipes;

  HomeLoaded(this.recipes);

  @override
  List<Object?> get props => [recipes];
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
