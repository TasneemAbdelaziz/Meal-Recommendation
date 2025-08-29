import 'dart:io';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:recipe_app_withai/core/common/cubits/app_users/app_user_cubit.dart';
import 'package:recipe_app_withai/core/secrets/app_secrets.dart';
import 'package:recipe_app_withai/features/auth/data/data_sources/supabase_datasource.dart';
import 'package:recipe_app_withai/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:recipe_app_withai/features/auth/domain/repositories/auth_repositories.dart';
import 'package:recipe_app_withai/features/auth/domain/use_cases/current_user.dart';
import 'package:recipe_app_withai/features/auth/domain/use_cases/google_sign_in.dart';
import 'package:recipe_app_withai/features/auth/domain/use_cases/user_sign_in.dart';
import 'package:recipe_app_withai/features/auth/domain/use_cases/user_sign_up.dart';
import 'package:recipe_app_withai/features/auth/presentation/manager/auth_bloc.dart';
import 'package:recipe_app_withai/features/home/data/data_sources/meal_remote_data_source.dart';
import 'package:recipe_app_withai/features/home/data/repositories/recipe_repository_impl.dart';
import 'package:recipe_app_withai/features/home/domian/repositories/recipe_repository.dart';
import 'package:recipe_app_withai/features/home/domian/use_cases/add_recipe_usecase.dart';
import 'package:recipe_app_withai/features/home/domian/use_cases/get_recipes.dart';
import 'package:recipe_app_withai/features/home/domian/use_cases/toggle_favorite.dart';
import 'package:recipe_app_withai/features/home/presentation/bloc/recipe/recipe_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // Initialize Supabase
  try {
    final supabase = await Supabase.initialize(
      url: AppSecrets.SupabaseUrl,
      anonKey: AppSecrets.SupabaseAnnokey,
    );
    serviceLocator.registerSingleton<SupabaseClient>(supabase.client);
    print("Supabase Initialized Successfully");
  } catch (e) {
    print("Failed to initialize Supabase: $e");
    rethrow;
  }

  // Initialize Google Sign-In
  serviceLocator.registerLazySingleton<GoogleSignIn>(
    () => GoogleSignIn(
      scopes: ['email'],
      clientId: Platform.isAndroid ? AppSecrets.googleAndroidClientId : null,
      serverClientId: AppSecrets.googleWebClientId,
    ),
  );

  serviceLocator.registerLazySingleton(() => AppUserCubit());

  // Initialize Auth dependencies
  initAuth();
  _initRecipe();
}

void initAuth() {
  // Data sources
  serviceLocator.registerFactory<SupabaseDatasource>(
    () => SupabaseDatasourceImpl(
      supabaseClient: serviceLocator(),
      googleSignIn: serviceLocator(),
    ),
  );

  // Repositories
  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(serviceLocator()),
  );

  // Use cases
  serviceLocator
    ..registerFactory(() => UserSignUp(serviceLocator()))
    ..registerFactory(() => UserSignIn(serviceLocator()))
    ..registerFactory(() => CurrentUser(serviceLocator()))
    ..registerFactory(() => GoogleSignInUseCase(serviceLocator()));

  // Bloc
  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      appUserCubit: serviceLocator(),
      googleSignInUseCase: serviceLocator(),
      userSignUp: serviceLocator(),
      userSignIn: serviceLocator(),
      currentUser: serviceLocator(),
    ),
  );
}

void _initRecipe() {
  serviceLocator
    ..registerFactory<RecipeRemoteDataSource>(
      () => RecipeRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<RecipeRepository>(
      () => RecipeRepositoryImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UploadRecipe(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetRecipes(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => ToggleFavorite(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => RecipeBloc(
        serviceLocator(),
      ),
    );
}
