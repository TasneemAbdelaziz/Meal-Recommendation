import 'package:fpdart/src/either.dart';
import 'package:recipe_app_withai/core/common/entities/my_user.dart';
import 'package:recipe_app_withai/core/errors/failure.dart';
import 'package:recipe_app_withai/core/usecase/usecase.dart';
import 'package:recipe_app_withai/features/auth/domain/repositories/auth_repositories.dart';

class UserSignIn implements UseCase<MyUser,UserSignInParams>{
  final AuthRepository authRepository;
  const UserSignIn(this.authRepository);
  @override
  Future<Either<Failure, MyUser>> call(UserSignInParams params) async{
    return await authRepository.signInWithEmailAndPassword(email: params.email, password: params.password);
  }

}
class UserSignInParams{
  final String email;
  final String password;
  UserSignInParams({
    required this.email,
    required this.password
  });
}