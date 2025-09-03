part of 'home_bloc.dart';

@immutable

abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

// class HomeLoaded extends HomeState {
//   final List<RecipeModel> recipes;
//
//   HomeLoaded(this.recipes);
//
//   @override
//   List<Object?> get props => [recipes];
// }

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
