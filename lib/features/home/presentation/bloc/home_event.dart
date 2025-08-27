import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSuggestionsEvent extends HomeEvent {}

class LoadAllRecipesEvent extends HomeEvent {}

class SearchRecipesEvent extends HomeEvent {
  final String query;

  SearchRecipesEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class ToggleFavoriteEvent extends HomeEvent {
  final String title;

  ToggleFavoriteEvent(this.title);

  @override
  List<Object?> get props => [title];
}
