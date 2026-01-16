import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app_withai/core/common/cubits/app_users/app_user_cubit.dart';

import 'package:recipe_app_withai/features/profile/domain/entities/profile_entity.dart';
import 'package:recipe_app_withai/features/profile/presentation/manager/profile_bloc.dart';
import 'package:recipe_app_withai/features/profile/presentation/pages/widgets/profile_error_view.dart';
import 'package:recipe_app_withai/features/profile/presentation/pages/widgets/profile_form.dart';
import 'package:recipe_app_withai/features/profile/presentation/pages/widgets/profile_loading_view.dart';


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
          if (state is ProfileLoaded) {
            _fillTextFields(state.profile);
          } else if (state is ProfileUpdateSuccess) {
            _fillTextFields(state.profile);
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
            return const ProfileLoadingView();
          }

          if (state is ProfileLoaded || state is ProfileUpdateSuccess) {
            final profile = state is ProfileLoaded
                ? state.profile
                : (state as ProfileUpdateSuccess).profile;

            return ProfileForm(
              usernameController: _usernameController,
              emailController: _emailController,
              phoneController: _phoneController,
              passwordController: _passwordController,
              onSave: _updateProfile,
              nameHint: profile.username,
              emailHint: profile.email,
              phoneHint: profile.phone ?? '',
            );
          }

          if (state is ProfileFailure) {
            return ProfileErrorView(
              message: state.message,
              onRetry: () {
                final userState = context.read<AppUserCubit>().state;
                if (userState is AppUserLoggedIn) {
                  context.read<ProfileBloc>().add(
                    ProfileLoadRequested(userState.user.id),
                  );
                }
              },
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

            return ProfileForm(
              usernameController: _usernameController,
              emailController: _emailController,
              phoneController: _phoneController,
              passwordController: _passwordController,
              onSave: _updateProfile,
              nameHint: userState.user.name,
              emailHint: userState.user.email,
              phoneHint: userState.user.phone,
            );
          }

          return const Center(child: Text('User not logged in'));
        },
      ),
    );
  }
}



