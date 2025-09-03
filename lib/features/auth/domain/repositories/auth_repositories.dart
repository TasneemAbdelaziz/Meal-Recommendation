import 'package:fpdart/fpdart.dart';
import 'package:recipe_app_withai/core/common/entities/my_user.dart';
import 'package:recipe_app_withai/core/errors/failure.dart';
import 'package:recipe_app_withai/features/auth/data/models/user_model.dart';

abstract interface class AuthRepository{
  Future<Either<Failure,MyUser>> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
    required String phone
  });
  Future<Either<Failure,MyUser>>  signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<Either<Failure,MyUser>> currentUser();
  Future<Either<Failure,MyUser>> signInWithGoogle();

}