import 'package:fpdart/fpdart.dart';
import 'package:recipe_app_withai/core/errors/failure.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileParams {
  final ProfileEntity profile;
  
  UpdateProfileParams({required this.profile});
}

class UpdateProfileUseCase {
  final ProfileRepository repository;
  
  UpdateProfileUseCase(this.repository);

  Future<Either<Failure, Unit>> call(UpdateProfileParams params) {
    return repository.updateProfile(params.profile);
  }
}
