import 'package:flutter/material.dart';
import 'package:recipe_app_withai/features/profile/presentation/pages/widgets/custom_text_feild.dart';
import 'package:recipe_app_withai/features/profile/presentation/pages/widgets/profile_circle_avatar.dart';
import 'package:recipe_app_withai/features/profile/presentation/pages/widgets/profile_save_button.dart';

class ProfileForm extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final VoidCallback onSave;
  final String nameHint;
  final String emailHint;
  final String phoneHint;

  const ProfileForm({
    super.key,
    required this.usernameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.onSave,
    required this.nameHint,
    required this.emailHint,
    required this.phoneHint,
  });

  @override
  Widget build(BuildContext context) {
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
                controller: usernameController,
                hint: nameHint,
              ),
              const SizedBox(height: 20),
              CustomTextFeild(
                controller: emailController,
                hint: emailHint,
              ),
              const SizedBox(height: 20),
              CustomTextFeild(
                controller: phoneController,
                labelText: 'Phone Number',
                hint: phoneHint,
              ),
              const SizedBox(height: 20),
              CustomTextFeild(
                controller: passwordController,
                labelText: 'Password',
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ProfileSaveButton(onPressed: onSave),
            ],
          ),
        ],
      ),
    );
  }
}
