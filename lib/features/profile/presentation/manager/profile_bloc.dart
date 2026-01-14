import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:recipe_app_withai/core/common/cubits/app_users/app_user_cubit.dart';
import 'package:recipe_app_withai/features/profile/domain/entities/profile_entity.dart';
import 'package:recipe_app_withai/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:recipe_app_withai/features/profile/domain/usecases/update_profile_usecase.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final AppUserCubit _appUserCubit;

  ProfileBloc({
    required GetProfileUseCase getProfileUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
    required AppUserCubit appUserCubit,
  })  : _getProfileUseCase = getProfileUseCase,
        _updateProfileUseCase = updateProfileUseCase,
        _appUserCubit = appUserCubit,
        super(ProfileInitial()) {
    on<ProfileLoadRequested>(_onProfileLoadRequested);
    on<ProfileUpdateRequested>(_onProfileUpdateRequested);
  }

  void _onProfileLoadRequested(
    ProfileLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final result = await _getProfileUseCase(event.userId);
    result.fold(
      (failure) => emit(ProfileFailure(failure.message)),
      (profile) => emit(ProfileLoaded(profile)),
    );
  }

  void _onProfileUpdateRequested(
    ProfileUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final result = await _updateProfileUseCase(
      UpdateProfileParams(profile: event.profile),
    );
    result.fold(
      (failure) => emit(ProfileFailure(failure.message)),
      (_) {
        // Update AppUserCubit to keep it in sync
        // Note: We need to convert ProfileEntity to MyUser
        // This might require mapping logic depending on your entity structures
        emit(ProfileUpdateSuccess(event.profile));
      },
    );
  }
}
