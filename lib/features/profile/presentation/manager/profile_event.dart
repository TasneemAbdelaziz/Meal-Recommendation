part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

final class ProfileLoadRequested extends ProfileEvent {
  final String userId;
  
  ProfileLoadRequested(this.userId);
}

final class ProfileUpdateRequested extends ProfileEvent {
  final ProfileEntity profile;
  
  ProfileUpdateRequested(this.profile);
}
