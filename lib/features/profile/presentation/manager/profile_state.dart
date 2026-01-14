part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  final ProfileEntity profile;
  
  ProfileLoaded(this.profile);
}

final class ProfileUpdateSuccess extends ProfileState {
  final ProfileEntity profile;
  
  ProfileUpdateSuccess(this.profile);
}

final class ProfileFailure extends ProfileState {
  final String message;
  
  ProfileFailure(this.message);
}
