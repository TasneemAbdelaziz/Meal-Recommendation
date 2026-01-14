import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe_app_withai/core/common/cubits/app_users/app_user_cubit.dart';
import 'package:recipe_app_withai/core/theme/app_pallet.dart';
import 'package:recipe_app_withai/features/profile/domain/entities/profile_entity.dart';
import 'package:recipe_app_withai/features/profile/presentation/manager/profile_bloc.dart';
import 'package:recipe_app_withai/features/profile/presentation/pages/widgets/custom_text_feild.dart';
import 'package:recipe_app_withai/features/profile/presentation/pages/widgets/profile_circle_avatar.dart';
import 'dart:developer';

class ProfilePage extends StatefulWidget {
  static const routeName = "ProfilePage";
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load profile data when page initializes
    final userState = context.read<AppUserCubit>().state;
    if (userState is AppUserLoggedIn) {
      context.read<ProfileBloc>().add(ProfileLoadRequested(userState.user.id));
    }
  }

  void _fillTextFields(ProfileEntity profile) {
    _usernameController.text = profile.username;
    _emailController.text = profile.email;
    _phoneController.text = profile.phone ?? '';
  }

  void _updateProfile() {
    if (_usernameController.text.trim().length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name must be at least 3 characters.')),
      );
      return;
    }

    final userState = context.read<AppUserCubit>().state;
    if (userState is! AppUserLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No user logged in')),
      );
      return;
    }

    // Create updated profile entity
    final updatedProfile = ProfileEntity(
      id: userState.user.id,
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
    );

    // Dispatch update event
    context.read<ProfileBloc>().add(ProfileUpdateRequested(updatedProfile));
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم تحديث البيانات بنجاح!')),
            );
            
            // Update AppUserCubit to keep it in sync
            final userState = context.read<AppUserCubit>().state;
            if (userState is AppUserLoggedIn) {
              final updatedUser = userState.user.copyWith(
                name: state.profile.username,
                email: state.profile.email,
                phone: state.profile.phone ?? '',
              );
              context.read<AppUserCubit>().updateUser(updatedUser);
            }
          } else if (state is ProfileFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfileLoaded || state is ProfileUpdateSuccess) {
            final profile = state is ProfileLoaded 
                ? state.profile 
                : (state as ProfileUpdateSuccess).profile;
            
            // Fill text fields with profile data
            if (_usernameController.text.isEmpty) {
              _fillTextFields(profile);
            }

            return Padding(
              padding: const EdgeInsets.all(10),
              child: ListView(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 10),
                      const ProfileCircleAvatar(),
                      const SizedBox(height: 20),
                      CustomTextFeild(
                        controller: _usernameController,
                        labelText: 'User Name',
                      ),
                      const SizedBox(height: 20),
                      CustomTextFeild(
                        controller: _emailController,
                        labelText: 'Email',
                      ),
                      const SizedBox(height: 20),
                      CustomTextFeild(
                        controller: _phoneController,
                        labelText: 'Phone Number',
                      ),
                      const SizedBox(height: 20),
                      CustomTextFeild(
                        controller: _passwordController,
                        labelText: 'Password',
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: 400.w,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppPallet.mainColor,
                            padding: EdgeInsets.symmetric(
                              horizontal: 30.w,
                              vertical: 15.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          onPressed: _updateProfile,
                          child: Text(
                            'Save',
                            style: TextStyle(
                              color: AppPallet.whiteColor,
                              fontSize: 25.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }

          if (state is ProfileFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      final userState = context.read<AppUserCubit>().state;
                      if (userState is AppUserLoggedIn) {
                        context.read<ProfileBloc>().add(
                          ProfileLoadRequested(userState.user.id),
                        );
                      }
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Initial state - try to load from AppUserCubit
          final userState = context.read<AppUserCubit>().state;
          if (userState is AppUserLoggedIn) {
            // Auto-fill from AppUserCubit for initial display
            if (_usernameController.text.isEmpty) {
              _usernameController.text = userState.user.name;
              _emailController.text = userState.user.email;
              _phoneController.text = userState.user.phone;
            }

            return Padding(
              padding: const EdgeInsets.all(10),
              child: ListView(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 10),
                      const ProfileCircleAvatar(),
                      const SizedBox(height: 20),
                      CustomTextFeild(
                        controller: _usernameController,
                        labelText: 'User Name',
                      ),
                      const SizedBox(height: 20),
                      CustomTextFeild(
                        controller: _emailController,
                        labelText: 'Email',
                      ),
                      const SizedBox(height: 20),
                      CustomTextFeild(
                        controller: _phoneController,
                        labelText: 'Phone Number',
                      ),
                      const SizedBox(height: 20),
                      CustomTextFeild(
                        controller: _passwordController,
                        labelText: 'Password',
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: 400.w,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppPallet.mainColor,
                            padding: EdgeInsets.symmetric(
                              horizontal: 30.w,
                              vertical: 15.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          onPressed: _updateProfile,
                          child: Text(
                            'Save',
                            style: TextStyle(
                              color: AppPallet.whiteColor,
                              fontSize: 25.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text('User not logged in'));
        },
      ),
    );
  }
}

