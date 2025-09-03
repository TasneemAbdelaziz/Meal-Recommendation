import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app_withai/core/common/entities/my_user.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit() : super(AppUserInitial());

  void updateUser(MyUser? user){
    if(user == null){
      emit(AppUserInitial());
    }else{
      emit(AppUserLoggedIn(user));
    }
  }
}
