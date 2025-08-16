import 'package:flutter/material.dart';
import 'package:recipe_app_withai/core/theme/app_pallet.dart';
import 'package:recipe_app_withai/features/home/presentation/pages/ingerent.dart';
import 'add_recipe_page.dart';

class HomePage extends StatefulWidget {
  static const routeName = "/home";

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: "Search recipes...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                backgroundColor: AppPallet.mainColor,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddRecipeForm(),
                    ),
                  );
                },
                child: const Text("Add your ingredients",style: TextStyle(color: AppPallet.whiteColor),),
              ),
            ),
            const SizedBox(height: 10),
            const Expanded(
              child: Center(
                child: Text("Search results will appear here..."),
              ),
            ),
          ],
        ),
      ),
    );
  }
}