import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:recipe_app_withai/core/common/cubits/app_users/app_user_cubit.dart';
import 'package:recipe_app_withai/core/common/entities/my_user.dart';
import 'package:recipe_app_withai/core/usecase/usecase.dart';
import 'package:recipe_app_withai/features/auth/domain/use_cases/current_user.dart';
import 'package:recipe_app_withai/features/auth/domain/use_cases/google_sign_in.dart';
import 'package:recipe_app_withai/features/auth/domain/use_cases/user_sign_in.dart';
import 'package:recipe_app_withai/features/auth/domain/use_cases/user_sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;
  final CurrentUser _currentUser;
  final GoogleSignInUseCase _googleSignInUseCase;
  final AppUserCubit _appUserCubit;



  AuthBloc({
    required UserSignUp userSignUp,
    required UserSignIn userSignIn,
    required CurrentUser currentUser,
    required GoogleSignInUseCase googleSignInUseCase,
    required AppUserCubit appUserCubit,
  }) : _userSignUp = userSignUp,
  _userSignIn = userSignIn,
  _currentUser =currentUser,
   _googleSignInUseCase = googleSignInUseCase,
        _appUserCubit = appUserCubit,

      super(AuthInitial()) {
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthSignIn>(_onAuthSignIn);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
    on<AuthGoogleSignIn>(_onGoogleSignIn);
    on<AuthEvent>((_,emit)=>emit(AuthLoading()));


  }
  void _isUserLoggedIn(
      AuthIsUserLoggedIn event,Emitter<AuthState> emit
      )async{
    final res = await _currentUser(NoParams());
    res.fold(
      (l)=>emit(AuthFailure(l.message))
    , (r)=> _emitAuthSuccess(r,emit)
    );
  }

  void _onAuthSignUp(
      AuthSignUp event,Emitter<AuthState> emit
      )async{
    // emit(AuthLoading());
    final res = await _userSignUp(UserSignUpParams(name:event.name ,password: event.password, email: event.email,phone: event.phone ));
    res.fold(
            (l) => emit(AuthFailure(l.message)), (r)=> _emitAuthSuccess(r,emit));
  }

  void _onAuthSignIn(
      AuthSignIn event,Emitter<AuthState> emit
      )async{
    // emit(AuthLoading());
    final res = await _userSignIn(UserSignInParams(password: event.password, email: event.email ));
    res.fold(
            (l) => emit(AuthFailure(l.message)), (user) =>_emitAuthSuccess(user,emit));

  }

  void _onGoogleSignIn(
      AuthGoogleSignIn event, Emitter<AuthState> emit) async {
    // emit(AuthLoading());
    final res = await _googleSignInUseCase(NoParams());
    res.fold(
            (l)=>emit(AuthFailure(l.message))
        ,
            (r)=> _emitAuthSuccess(r,emit)
    );
  }
  void _emitAuthSuccess(MyUser user,Emitter<AuthState>emit) async {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }
}