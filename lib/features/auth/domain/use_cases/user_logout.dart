import 'package:fpdart/fpdart.dart';
import 'package:recipe_app_withai/core/errors/failure.dart';
import 'package:recipe_app_withai/core/usecase/usecase.dart';
import 'package:recipe_app_withai/features/auth/domain/repositories/auth_repositories.dart';

class UserLogout implements UseCase<void, NoParams> {
  final AuthRepository _authRepository;

  UserLogout(this._authRepository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await _authRepository.logout();
  }
}
