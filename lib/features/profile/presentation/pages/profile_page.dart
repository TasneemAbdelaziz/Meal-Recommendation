import 'package:flutter/material.dart';
import 'package:recipe_app_withai/features/profile/presentation/pages/widgets/custom_text_feild.dart';
import 'package:recipe_app_withai/features/profile/presentation/pages/widgets/profile_circle_avatar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
void main() {
  runApp(MaterialApp(
    home: ProfilePage(),
  ));
}

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
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;
    final response = await Supabase.instance.client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .single();
    setState(() {
      _usernameController.text = response['name'] ?? '';
      _phoneController.text = response['phone'] ?? '';
      _emailController.text = user.email ?? '';
      _loading = false;
    });
  }

  Future<void> _updateProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;
    if (_usernameController.text.trim().length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name must be at least 3 characters.')),
      );
      return;
    }
    await Supabase.instance.client.from('profiles').update({
      'name': _usernameController.text,
      'phone': _phoneController.text,
    }).eq('id', user.id);
    if (_emailController.text.isNotEmpty && _emailController.text != user.email) {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(email: _emailController.text),
      );
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم تحديث البيانات بنجاح!')),
    );
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
      // backgroundColor: AppColors.backgroundColor,
      
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  ProfileCircleAvatar(),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(labelText: 'Username'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      controller: _phoneController,
                      decoration: const InputDecoration(labelText: 'Phone Number'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      width: 400,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextButton(
                        onPressed: _updateProfile,
                        child: const Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}


