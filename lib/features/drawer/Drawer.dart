import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app_withai/features/auth/presentation/manager/auth_bloc.dart';
import 'package:recipe_app_withai/features/auth/presentation/pages/sign_in_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

class AppDrawer extends StatelessWidget {
   final int selectedIndex;
   final ValueChanged<int> onDestinationSelected;

   const AppDrawer({super.key,required this.selectedIndex,required this.onDestinationSelected});

  Future<Map<String, dynamic>?> fetchUserData() async {
    final user = Supabase.instance.client.auth.currentUser;
    // log('Current user: \\${user?.id}');
    if (user == null) return null;
    final response = await Supabase.instance.client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .single();
    // log('Supabase response: \\${response.toString()}');
    // Add email from auth if not in response
    if (!response.containsKey('email')) {
      response['email'] = user.email;
    }
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          // Navigate to sign in page and clear history
          Navigator.pushNamedAndRemoveUntil(
            context,
            SignIn.routeName,
            (route) => false,
          );
        }
      },
      child: FutureBuilder<Map<String, dynamic>?>(
        future: fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('لم يتم العثور على بيانات المستخدم'));
          }

          final userData = snapshot.data!;

          return NavigationDrawer(
            selectedIndex: selectedIndex,
            onDestinationSelected: (value) {
              if (value == 3) {
                // Logout destination index
                context.read<AuthBloc>().add(AuthLogout());
                return;
              }
              Navigator.pop(context); // close drawer
              onDestinationSelected(value); // update parent state
            },
            header: Column(
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(userData['username'] ?? 'اسم المستخدم'),
                  accountEmail: Text(userData['email'] ?? 'البريد الإلكتروني'),
                  currentAccountPicture: userData['avatar_url'] != null &&
                          userData['avatar_url'].toString().isNotEmpty
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(userData['avatar_url']),
                        )
                      : const CircleAvatar(),
                ),
              ],
            ),
            children: const [
              NavigationDrawerDestination(
                icon: Icon(Icons.home),
                label: Text("Home"),
              ),
              NavigationDrawerDestination(
                icon: Icon(Icons.favorite),
                label: Text("Favorite"),
              ),
              NavigationDrawerDestination(
                icon: Icon(Icons.person),
                label: Text("Profile"),
              ),
              Divider(),
              NavigationDrawerDestination(
                icon: Icon(Icons.logout),
                label: Text("Logout"),
              ),
            ],
          );
        },
      ),
    );
  }
}