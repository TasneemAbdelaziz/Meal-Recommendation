import 'package:fpdart/src/either.dart';
import 'package:recipe_app_withai/core/common/entities/my_user.dart';
import 'package:recipe_app_withai/core/errors/failure.dart';
import 'package:recipe_app_withai/features/auth/data/data_sources/supabase_datasource.dart';
import 'package:recipe_app_withai/features/auth/domain/repositories/auth_repositories.dart';

class AuthRepositoryImpl implements AuthRepository{
  SupabaseDatasource supabaseDatasource;
  AuthRepositoryImpl(this.supabaseDatasource);
  @override
  Future<Either<Failure, MyUser>> currentUser() async{
    try{
      final user = await supabaseDatasource.getCurrentUserData();
      if(user == null)
      {
        return left(Failure("User not logged in"));
      }
      return right(user);
    }
    catch(e){
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MyUser>> signInWithEmailAndPassword({required String email, required String password}) async{
    try{
      final user = await supabaseDatasource.signInWithEmailPassword(email: email, password: password);
      return right(user);
    }
    catch(e){
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MyUser>> signUpWithEmailAndPassword({required String name, required String email, required String password, required String phone})async {
    try{
      final user = await supabaseDatasource.signUpWithEmailPassword(phone: phone,email: email,password: password,name: name);
      return right(user);
    }
    catch(e){
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MyUser>> signInWithGoogle() async{
    try{
      final user = await supabaseDatasource.signInWithGoogle();
      return right(user);
    }
    catch(e){
      return left(Failure(e.toString()));
    }
  }

}