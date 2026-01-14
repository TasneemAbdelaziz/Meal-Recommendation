import 'dart:io';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:recipe_app_withai/core/common/cubits/app_users/app_user_cubit.dart';
import 'package:recipe_app_withai/core/secrets/app_secrets.dart';
import 'package:recipe_app_withai/features/add_recipe/data/data_sources/meal_remote_data_source.dart';
import 'package:recipe_app_withai/features/add_recipe/data/repositories/recipe_repository_impl.dart';
import 'package:recipe_app_withai/features/add_recipe/domian/repositories/recipe_repository.dart';
import 'package:recipe_app_withai/features/add_recipe/domian/use_cases/add_recipe_usecase.dart';
import 'package:recipe_app_withai/features/add_recipe/presentation/manager/recipe_bloc.dart';
import 'package:recipe_app_withai/features/auth/data/data_sources/supabase_datasource.dart';
import 'package:recipe_app_withai/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:recipe_app_withai/features/auth/domain/repositories/auth_repositories.dart';
import 'package:recipe_app_withai/features/auth/domain/use_cases/current_user.dart';
import 'package:recipe_app_withai/features/auth/domain/use_cases/google_sign_in.dart';
import 'package:recipe_app_withai/features/auth/domain/use_cases/user_sign_in.dart';
import 'package:recipe_app_withai/features/auth/domain/use_cases/user_sign_up.dart';
import 'package:recipe_app_withai/features/auth/presentation/manager/auth_bloc.dart';
import 'package:recipe_app_withai/features/favorite/data/datasources/favorites_local_datasource.dart';
import 'package:recipe_app_withai/features/favorite/data/datasources/favorites_remote_datasource.dart';
import 'package:recipe_app_withai/features/favorite/data/repositories/favorites_repository_impl.dart';
import 'package:recipe_app_withai/features/favorite/domain/repository/favorites_repository.dart';
import 'package:recipe_app_withai/features/favorite/domain/usecases/GetCachedFavoriteIdsUseCase.dart';
import 'package:recipe_app_withai/features/favorite/domain/usecases/SyncFavoritesUseCase.dart';
import 'package:recipe_app_withai/features/favorite/domain/usecases/ToggleFavoriteUseCase.dart';
import 'package:recipe_app_withai/features/favorite/presentation/bloc/favorites_bloc.dart';
import 'package:recipe_app_withai/features/home/data/data_source/home_remote_data_source.dart';
import 'package:recipe_app_withai/features/home/data/repositories/home_repositoryImpl.dart';
import 'package:recipe_app_withai/features/home/domain/repositories/home_repository.dart';
import 'package:recipe_app_withai/features/home/domain/use_cases/get_all_recipes.dart';
import 'package:recipe_app_withai/features/home/presentation/manager/home_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:recipe_app_withai/features/ai_chat/data/datasources/gemini_remote_data_source.dart';
import 'package:recipe_app_withai/features/ai_chat/data/datasources/spoonacular_remote_data_source.dart';
import 'package:recipe_app_withai/features/ai_chat/data/repositories_impl/ai_recipe_repository_impl.dart';
import 'package:recipe_app_withai/features/ai_chat/domain/repositories/ai_recipe_repository.dart';
import 'package:recipe_app_withai/features/ai_chat/domain/usecases/parse_user_query_usecase.dart';
import 'package:recipe_app_withai/features/ai_chat/domain/usecases/search_recipes_usecase.dart';
import 'package:recipe_app_withai/features/ai_chat/presentation/bloc/ai_recipe_bloc.dart';
import 'package:recipe_app_withai/recipe_description/data/datasources/supabase_recipe_details_datasource.dart';
import 'package:recipe_app_withai/recipe_description/data/datasources/spoonacular_recipe_details_datasource.dart';
import 'package:recipe_app_withai/recipe_description/data/repositories_impl/recipe_details_repository_impl.dart';
import 'package:recipe_app_withai/recipe_description/domain/repositories/recipe_details_repository.dart';
import 'package:recipe_app_withai/recipe_description/domain/usecases/get_recipe_details_usecase.dart';
import 'package:recipe_app_withai/recipe_description/presentation/bloc/recipe_details_bloc.dart';
import 'package:recipe_app_withai/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:recipe_app_withai/features/profile/data/datasources/profile_remote_datasource_impl.dart';
import 'package:recipe_app_withai/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:recipe_app_withai/features/profile/domain/repositories/profile_repository.dart';
import 'package:recipe_app_withai/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:recipe_app_withai/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:recipe_app_withai/features/profile/presentation/manager/profile_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:recipe_app_withai/core/utils/connectivity_checker.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // Validate and initialize Supabase
  try {
    // Validate Supabase URL
    final supabaseUrl = AppSecrets.SupabaseUrl.trim();
    final anonKey = AppSecrets.SupabaseAnnokey.trim();
    
    // Debug logging
    print('\n🔍 Supabase Configuration Check:');
    print('📍 URL: ${supabaseUrl.replaceAll(RegExp(r'https://([^.]+)'), 'https://***')}.supabase.co');
    print('🔑 AnonKey length: ${anonKey.length} characters');
    
    // Validate URL format
    if (!supabaseUrl.startsWith('https://') || !supabaseUrl.contains('.supabase.co')) {
      throw Exception('Invalid Supabase URL format. Expected: https://<project-ref>.supabase.co');
    }
    
    if (supabaseUrl.isEmpty || anonKey.isEmpty) {
      throw Exception('Supabase URL or AnonKey is empty');
    }
    
    print('✅ Supabase configuration validated successfully');
    
    final supabase = await Supabase.initialize(
      url: supabaseUrl,
      anonKey: anonKey,
    );
    
    serviceLocator.registerSingleton<SupabaseClient>(supabase.client);
    print("✅ Supabase initialized successfully\n");
  } catch (e) {
    print("❌ Failed to initialize Supabase: $e");
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

  // Register Connectivity
  serviceLocator.registerLazySingleton<Connectivity>(() => Connectivity());
  serviceLocator.registerLazySingleton<ConnectivityChecker>(
    () => ConnectivityChecker(serviceLocator()),
  );

  serviceLocator.registerLazySingleton(
        () => AppUserCubit()
  );
  
  serviceLocator.registerLazySingleton(() => http.Client());
  // Favorite
  final prefs = await SharedPreferences.getInstance();
  serviceLocator.registerSingleton<SharedPreferences>(prefs);

  initFavorites();
  // Initialize Auth dependencies
  initAuth();
  _initRecipe();

  _initHome();
  _initAiRecipe();
  _initRecipeDetails();
  _initProfile();
}


void initFavorites() {
  serviceLocator
  // Data sources
    ..registerFactory<FavoritesRemoteDataSource>(
          () => FavoritesRemoteDataSourceImpl(serviceLocator()),
    )
    ..registerFactory<FavoritesLocalDataSource>(
          () => FavoritesLocalDataSourceImpl(serviceLocator<SharedPreferences>()),
    )

  // Repository
    ..registerFactory<FavoritesRepository>(
          () => FavoritesRepositoryImpl(
        remote: serviceLocator(),
        local: serviceLocator(),
      ),
    )

  // UseCases
    ..registerFactory(() => GetCachedFavoriteIdsUseCase(serviceLocator()))
    ..registerFactory(() => SyncFavoritesUseCase(serviceLocator()))
    ..registerFactory(() => ToggleFavoriteUseCase(serviceLocator()))

  // Bloc
    ..registerLazySingleton(
          () => FavoritesBloc(
        getCachedFavoriteIdsUseCase: serviceLocator(),
        syncFavoritesUseCase: serviceLocator(),
        toggleFavoriteUseCase: serviceLocator(),
      ),
    );
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
    () => AuthRepositoryImpl(
      serviceLocator(),
      serviceLocator<ConnectivityChecker>(),
    ),
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
    ..registerLazySingleton(
      () => RecipeBloc(
        serviceLocator(),
      ),
    );
}

void _initHome() {
  // Data sources
  serviceLocator
    ..registerFactory<HomeRemoteDataSource>(
        () => HomeRemoteDataSourceImpl(
      supabaseClient: serviceLocator(),
    ),
  )

  // Repositories
  ..registerFactory<HomeRepository>(
        () => HomeRepositoryImpl(
      remoteDataSource: serviceLocator(),
    ),
  )

  // Use cases
  ..registerFactory(
        () => GetAllRecipes(
      serviceLocator(),
    ),
  )

  // Bloc - Use Factory if you want a new instance per widget
  // Use LazySingleton if you want a single instance across the app
  ..registerLazySingleton(
        () => HomeBloc(
      getAllRecipes: serviceLocator(),
    ),
  );
}


void _initAiRecipe() {
  // Data Sources
  serviceLocator
    ..registerFactory<GeminiRemoteDataSource>(
      () => GeminiRemoteDataSourceImpl(serviceLocator()),
    )
    ..registerFactory<SpoonacularRemoteDataSource>(
      () => SpoonacularRemoteDataSourceImpl(serviceLocator()),
    )
  // Repository
    ..registerFactory<AiRecipeRepository>(
      () => AiRecipeRepositoryImpl(
        geminiRemoteDataSource: serviceLocator(),
        spoonacularRemoteDataSource: serviceLocator(),
      ),
    )
  // UseCases
    ..registerFactory(() => ParseUserQueryUseCase(serviceLocator()))
    ..registerFactory(() => SearchRecipesUseCase(serviceLocator()))
  // Bloc
    ..registerFactory(
      () => AiRecipeBloc(
        parseUserQueryUseCase: serviceLocator(),
        searchRecipesUseCase: serviceLocator(),
      ),
    );
}

void _initRecipeDetails() {
  serviceLocator
    // Data Sources
    ..registerFactory(
      () => SupabaseRecipeDetailsDataSource(serviceLocator()),
    )
    ..registerFactory(
      () => SpoonacularRecipeDetailsDataSource(serviceLocator()),
    )
    // Repository
    ..registerFactory<RecipeDetailsRepository>(
      () => RecipeDetailsRepositoryImpl(
        supabaseDataSource: serviceLocator<SupabaseRecipeDetailsDataSource>(),
        spoonacularDataSource: serviceLocator<SpoonacularRecipeDetailsDataSource>(),
      ),
    )
    // Use Case
    ..registerFactory(
      () => GetRecipeDetailsUseCase(serviceLocator()),
    )
    // Bloc
    ..registerFactory(
      () => RecipeDetailsBloc(
        getRecipeDetails: serviceLocator(),
      ),
    );
}

void _initProfile() {
  serviceLocator
    // Data sources
    ..registerFactory<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(serviceLocator()),
    )
    // Repository
    ..registerFactory<ProfileRepository>(
      () => ProfileRepositoryImpl(serviceLocator()),
    )
    // Use cases
    ..registerFactory(() => GetProfileUseCase(serviceLocator()))
    ..registerFactory(() => UpdateProfileUseCase(serviceLocator()))
    // Bloc
    ..registerFactory(
      () => ProfileBloc(
        getProfileUseCase: serviceLocator(),
        updateProfileUseCase: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}
