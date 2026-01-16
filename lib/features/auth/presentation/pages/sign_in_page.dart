import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickalert/quickalert.dart';
import 'package:recipe_app_withai/core/theme/app_pallet.dart';
import 'package:recipe_app_withai/core/utils/validators.dart';
import 'package:recipe_app_withai/core/widgets/error_dialog.dart';
import 'package:recipe_app_withai/features/auth/presentation/manager/auth_bloc.dart';
import 'package:recipe_app_withai/features/auth/presentation/pages/sign_up_page.dart';
import 'package:recipe_app_withai/features/auth/presentation/widgets/auth_button.dart';
import 'package:recipe_app_withai/features/auth/presentation/widgets/auth_field.dart';
import 'package:recipe_app_withai/features/auth/presentation/widgets/check_box.dart';
import 'package:recipe_app_withai/features/auth/presentation/widgets/login_text_with_divider.dart';
import 'package:recipe_app_withai/features/auth/presentation/widgets/social_sign_in.dart';
import 'package:recipe_app_withai/translation/translation_page.dart';

class SignIn extends StatefulWidget {
  static const routeName = "SignIn";
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isChecked = false;

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallet.mainColor,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/cover.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Color overlay
          Container(
            color: AppPallet.mainColor.withOpacity(0.2), // Adjust opacity
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: SingleChildScrollView(
                  child: BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthFailure) {
                        Navigator.of(context, rootNavigator: true)
                            .popUntil((route) => route.isFirst);
                        
                        // Show error dialog with retry functionality
                        ErrorDialog.show(
                          context,
                          message: state.message,
                          errorType: state.errorType,
                          onRetry: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(AuthSignIn(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim()));
                            }
                          },
                        );
                      }
                      if (state is AuthLoading) {
                        Navigator.of(context, rootNavigator: true)
                            .popUntil((route) => route.isFirst);
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.loading,
                          title: 'Signing In',
                          text: 'Please wait...',
                        );
                      }
                      if (state is AuthSuccess) {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.success,
                          title: 'Sign-In Successful',
                          text: 'Welcome!',
                          autoCloseDuration: const Duration(seconds: 2),
                        );

                        // Navigate after delay to allow user to see success alert
                        Future.delayed(const Duration(seconds: 2), () {
                          Navigator.of(context)
                              .pushReplacementNamed(TransitionPage.routeName);
                        });
                      }
                    },
                    builder: (context, state) {
                      return Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset("assets/icons/logo.png",width: 128.w,height: 128.h,),
                            SizedBox(
                              height: 40.h,
                            ),
                            AuthField(
                              validator: validateEmail,
                              prefixIcon: Icons.person_2_outlined,
                              headName: "Email",
                              controller: emailController,
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            AuthField(
                              validator: validatePassword,
                              prefixIcon: Icons.person_2_outlined,
                              headName: "Password",
                              controller: passwordController,
                              obscureText: true,
                              suffixIcon: Icons.visibility_off,
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            MyCheckBox(
                                onChanged: (val) {
                                  setState(() {
                                    isChecked = val!;
                                  });
                                },
                                isChecked: isChecked,
                                text: "Rememper me and keep me login"),
                            AuthButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<AuthBloc>().add(AuthSignIn(
                                      email: emailController.text.trim(),
                                      password:
                                          passwordController.text.trim()));
                                }
                              },
                              buttomText: "Sign in",
                            ),
                            LoginWithDivider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/icons/facebook.png",
                                  width: 66.w,
                                  height: 66.h,
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                SocialSignInButton(authEvent: AuthGoogleSignIn(),imgUrl: "assets/icons/Google.png",),
                              ],
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushReplacementNamed(SignUp.routeName);
                                },
                                child: Text(
                                  "Don't have an account ? Register",
                                  style: TextStyle(color: AppPallet.whiteColor),
                                )),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
