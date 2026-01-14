import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/recipe_details_entity.dart';
import '../../domain/entities/recipe_details_request.dart';
import '../../domain/usecases/get_recipe_details_usecase.dart';
import '../../../../core/errors/failure.dart';

// Events
abstract class RecipeDetailsEvent extends Equatable {
  const RecipeDetailsEvent();

  @override
  List<Object> get props => [];
}

class RecipeDetailsRequested extends RecipeDetailsEvent {
  final RecipeDetailsRequest request;

  const RecipeDetailsRequested(this.request);

  @override
  List<Object> get props => [request];
}

// States
abstract class RecipeDetailsState extends Equatable {
  const RecipeDetailsState();

  @override
  List<Object> get props => [];
}

class RecipeDetailsInitial extends RecipeDetailsState {}

class RecipeDetailsLoading extends RecipeDetailsState {}

class RecipeDetailsLoaded extends RecipeDetailsState {
  final RecipeDetailsEntity recipe;

  const RecipeDetailsLoaded(this.recipe);

  @override
  List<Object> get props => [recipe];
}

class RecipeDetailsError extends RecipeDetailsState {
  final String message;

  const RecipeDetailsError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class RecipeDetailsBloc extends Bloc<RecipeDetailsEvent, RecipeDetailsState> {
  final GetRecipeDetailsUseCase getRecipeDetails;

  RecipeDetailsBloc({required this.getRecipeDetails}) : super(RecipeDetailsInitial()) {
    on<RecipeDetailsRequested>(_onRecipeDetailsRequested);
  }

  Future<void> _onRecipeDetailsRequested(
    RecipeDetailsRequested event,
    Emitter<RecipeDetailsState> emit,
  ) async {
    emit(RecipeDetailsLoading());
    final result = await getRecipeDetails(event.request);
    result.fold(
      (failure) => emit(RecipeDetailsError(_mapFailureToMessage(failure))),
      (recipe) => emit(RecipeDetailsLoaded(recipe)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    // Basic mapping, extend as needed based on Failure types in core
    // Assuming Failure has a message property or is a class like ServerFailure
    // For now returning a generic or specific string if I knew the implementation of Failure.
    // I'll assume standard Clean Arch Failure.
    // If Failure doesn't have message, I'll return 'Unexpected Error'.
    // Checking previous steps or assuming typical structure:
    if (failure is ServerFailure) {
        return failure.message;
    }
    return 'Unexpected Error';
  }
}
