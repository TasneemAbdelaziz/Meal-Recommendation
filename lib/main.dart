import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe_app_withai/core/common/cubits/app_users/app_user_cubit.dart';
import 'package:recipe_app_withai/core/init_dependencies.dart';
import 'package:recipe_app_withai/features/add_recipe/presentation/manager/recipe_bloc.dart';
import 'package:recipe_app_withai/features/add_recipe/presentation/pages/app_recipe_page.dart';
import 'package:recipe_app_withai/features/auth/presentation/manager/auth_bloc.dart';
import 'package:recipe_app_withai/features/auth/presentation/pages/sign_in_page.dart';
import 'package:recipe_app_withai/features/auth/presentation/pages/sign_up_page.dart';
import 'package:recipe_app_withai/features/favorite/presentation/pages/favorite_page.dart';
import 'package:recipe_app_withai/features/home/presentation/manager/home_bloc.dart';
import 'package:recipe_app_withai/features/home/presentation/pages/home_page.dart';
import 'package:recipe_app_withai/features/profile/presentation/pages/profile_page.dart';
import 'package:recipe_app_withai/features/recipe_details/presentation/pages/recipe_details_page.dart';
import 'package:recipe_app_withai/features/recipe_details/presentation/bloc/recipe_details_bloc.dart';
import 'package:recipe_app_withai/features/recipe_details/domain/use_cases/get_recipe_details_usecase.dart';
import 'package:recipe_app_withai/features/recipe_details/domain/use_cases/toggle_favorite_usecase.dart';
import 'package:recipe_app_withai/features/recipe_details/data/repositories_impl/recipe_details_repo_impl.dart';
import 'package:recipe_app_withai/core/theme/theme.dart';
import 'package:recipe_app_withai/onboarding/introduction_screen.dart';
import 'package:recipe_app_withai/onboarding/splash_screen.dart';
import 'package:recipe_app_withai/translation/translation_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(
      MultiBlocProvider(providers: [
        BlocProvider(
          create: (_) => serviceLocator<AppUserCubit>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<AuthBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<RecipeBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<HomeBloc>(),
        ),
      ],
          child: const MyApp()));
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightThemeMode,
        home: SplashScreen(),
        initialRoute: SplashScreen.routeName,
        routes: {
          IntroductionScreen.routeName: (_) =>  IntroductionScreen(),
          SignIn.routeName: (_) =>  SignIn(),
          SignUp.routeName: (_) =>  SignUp(),
          TransitionPage.routeName: (_) =>  TransitionPage(),
          HomePage.routeName: (_) =>  HomePage(),
          ProfilePage.routeName: (_) =>  ProfilePage(),
          FavoritePage.routeName: (_) => FavoritePage(),
          AddRecipePage.routeName:(_)=>AddRecipePage(),
          RecipeDetailsPage.routeName: (context) {
            final recipeId =
                ModalRoute.of(context)!.settings.arguments as String;
            return BlocProvider(
              create: (_) => RecipeDetailsBloc(
                GetRecipeDetailsUsecase(RecipeDetailsRepositoryImpl()),
                ToggleFavoriteUsecase(RecipeDetailsRepositoryImpl()),
              ),
              child: RecipeDetailsPage(recipeId: recipeId),
            );
          },
        },
      ),
    );
  }
}
