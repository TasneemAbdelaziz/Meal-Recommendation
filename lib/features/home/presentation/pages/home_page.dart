import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe_app_withai/core/theme/app_pallet.dart';
import 'package:recipe_app_withai/features/add_recipe/presentation/pages/app_recipe_page.dart';
import 'package:recipe_app_withai/features/home/domain/entities/recipe_entity.dart';
import 'package:recipe_app_withai/features/home/presentation/manager/home_bloc.dart';
import 'package:recipe_app_withai/features/home/presentation/widgets/cards/recipe_card.dart';

import '../../../chat/presentation/Screens/GeminiAiScreen.dart';

class HomePage extends StatefulWidget {
  static const String routeName = "HomePage";
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Load recipes when the page initializes
    context.read<HomeBloc>().add(LoadAllRecipesEvent());
  }
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // Search Bar with Add Button
          Container(
            // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search recipes...",
                        prefixIcon: const Icon(Icons.search, size: 20),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Container(
                //   width: 40,
                //   height: 40,
                //   decoration: BoxDecoration(
                //     color: AppPallet.mainColor,
                //     shape: BoxShape.circle,
                //   ),
                //   child:
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MealSuggestionScreen()),
                      );
                    },
                    icon:  Image.asset("assets/icons/gemini.png",width: 40.w,height: 40.h,),
                    padding: EdgeInsets.zero,
                  ),
                // ),
              ],
            ),

          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 200.w,
                height: 40.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25), // Rounded corners
                    color: AppPallet.mainColor,
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddRecipePage()),
                    ).then((value) {
                      // This runs when you return from AddRecipePage
                      if (value == true) { // Return true if recipe was added
                        context.read<HomeBloc>().add(LoadAllRecipesEvent());
                      }
                    });
                  },
                  child: Text("add your ingrediantes",style: TextStyle(color: AppPallet.whiteColor),),
                ),
              ),
            ],
          ),

          // Recipes List
          Expanded(
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is HomeLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is HomeLoaded) {
                  // Add null safety check for recipes list
                  final recipes = state.recipes ?? [];

                  if (recipes.isEmpty) {
                    return const Center(child: Text("No recipes available"));
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];
                      if (recipe == null) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: RecipeCard(recipe: recipe),
                      );
                    },
                  );
                } else if (state is HomeError) {
                  return Center(child: Text(state.message ?? "An error occurred"));
                }
                return const Center(child: Text("Loading..."));
              },
            ),
          ),
        ],
      ),
    );
  }
}