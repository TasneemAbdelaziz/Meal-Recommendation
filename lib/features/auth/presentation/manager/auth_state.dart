part of 'auth_bloc.dart';


@immutable
sealed class AuthState {
  AuthState();
}

class GoogleAuthSuccess extends AuthState {
  final MyUser user;
  GoogleAuthSuccess(this.user);
}
final class AuthInitial extends AuthState {}
final class AuthLoading extends AuthState {}
final class AuthSuccess extends AuthState {
  final MyUser user;
  AuthSuccess(this.user);
}
final class AuthFailure extends AuthState {
  final String message;
  final ErrorType? errorType;
  
  AuthFailure(this.message, {this.errorType});
}
