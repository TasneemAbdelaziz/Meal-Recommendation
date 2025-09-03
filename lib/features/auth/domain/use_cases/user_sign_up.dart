
import 'package:fpdart/fpdart.dart';
import 'package:recipe_app_withai/core/common/entities/my_user.dart';
import 'package:recipe_app_withai/core/errors/failure.dart';
import 'package:recipe_app_withai/core/usecase/usecase.dart';
import 'package:recipe_app_withai/features/auth/domain/repositories/auth_repositories.dart';

class UserSignUp implements UseCase<MyUser,UserSignUpParams>{
  final AuthRepository authRepository;
  const UserSignUp(this.authRepository);
  @override
  Future<Either<Failure, MyUser>> call(UserSignUpParams params) async{
    return await authRepository.signUpWithEmailAndPassword(name: params.name, email: params.email, password: params.password,phone: params.phone );
  }

}
class UserSignUpParams{
  final String email;
  final String name;
  final String password;
  final String phone;
  UserSignUpParams({
    required this.phone,
    required this.email,
    required this.name,
    required this.password
  });
}