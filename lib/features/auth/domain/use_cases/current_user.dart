import 'package:fpdart/fpdart.dart';
import 'package:recipe_app_withai/core/common/entities/my_user.dart';
import 'package:recipe_app_withai/core/errors/failure.dart';
import 'package:recipe_app_withai/core/usecase/usecase.dart';
import 'package:recipe_app_withai/features/auth/domain/repositories/auth_repositories.dart';


class CurrentUser implements UseCase<MyUser,NoParams>{

  final AuthRepository authRepository;
  CurrentUser(this.authRepository);

  Future<Either<Failure,MyUser>> call(NoParams params)async{
    return await authRepository.currentUser();
  }
}

