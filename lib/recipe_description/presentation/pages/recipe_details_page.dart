import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:recipe_app_withai/recipe_description/presentation/bloc/recipe_details_bloc.dart';
import 'package:recipe_app_withai/features/favorite/presentation/bloc/favorites_bloc.dart';
import 'package:recipe_app_withai/features/favorite/presentation/bloc/favorites_event.dart';
import 'package:recipe_app_withai/features/favorite/presentation/bloc/favorites_state.dart';
import 'package:recipe_app_withai/features/favorite/presentation/widgets/favorite_button.dart';
import 'package:recipe_app_withai/recipe_description/presentation/pages/widget/recipe_details_image.dart';
import 'package:recipe_app_withai/recipe_description/presentation/pages/widget/recipe_details_meta.dart';
import 'package:recipe_app_withai/recipe_description/presentation/pages/widget/recipe_details_title.dart';
import 'package:recipe_app_withai/recipe_description/presentation/pages/widget/recipe_directions.dart';
import 'package:recipe_app_withai/recipe_description/presentation/pages/widget/recipe_ingredients.dart';
import 'package:recipe_app_withai/recipe_description/presentation/pages/widget/recipe_summary.dart';
import '../../domain/entities/recipe_details_request.dart';

class RecipeDetailsPage extends StatefulWidget {
  final RecipeDetailsRequest request;

  const RecipeDetailsPage({Key? key, required this.request}) : super(key: key);

  @override
  State<RecipeDetailsPage> createState() => _RecipeDetailsPageState();
}

class _RecipeDetailsPageState extends State<RecipeDetailsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Dispatch event
    context.read<RecipeDetailsBloc>().add(RecipeDetailsRequested(widget.request));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Current User ID for favorites
    final userId = Supabase.instance.client.auth.currentUser?.id;
    final recipeId = widget.request.id;

    return Scaffold(
      backgroundColor: Colors.white, 
      appBar: AppBar(
        title: const Text('Recipe Details', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        actions: [
           Padding(
             padding: const EdgeInsets.only(right: 16.0),
             child: BlocBuilder<FavoritesBloc, FavoritesState>(
               buildWhen: (p, c) => p.favoriteIds != c.favoriteIds,
               builder: (context, favState) {
                 final isFav = favState.favoriteIds.contains(recipeId);

                 return GestureDetector(
                   onTap: userId == null
                       ? null
                       : () {
                           context.read<FavoritesBloc>().add(
                             FavoriteToggled(
                               userId: userId,
                               recipeId: recipeId,
                             ),
                           );
                         },
                   child: FavoriteButton(isFavorite: isFav), // Assuming FavoriteButton handles its own icon/color based on bool
                   // If FavoriteButton is complex, I might need to wrap it or use Icon directly if FavoriteButton has padding/issues in AppBar.
                   // Checking RecipeCard usage: child:FavoriteButton(isFavorite: isFav) inside GestureDetector.
                   // So it should be fine.
                 );
               },
             ),
           ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<RecipeDetailsBloc, RecipeDetailsState>(
          builder: (context, state) {
            if (state is RecipeDetailsLoading) {
              return const Center(child: CircularProgressIndicator(color: Colors.black));
            } else if (state is RecipeDetailsError) {
              return Center(child: Text(state.message, style: const TextStyle(color: Colors.black)));
            } else if (state is RecipeDetailsLoaded) {
               return _buildRecipeContent(context, state);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildRecipeContent(BuildContext context, RecipeDetailsLoaded state) {
    final recipe = state.recipe;

    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        children: [
          // Top Image Section
          RecipeDetailsImage(imageUrl: recipe.imageUrl),
          
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 16),
                // Title
                RecipeDetailsTitle(title: recipe.title),
                
                const SizedBox(height: 10),
                
                // Meta Row
                RecipeDetailsMeta(
                  categoryOrType: recipe.categoryOrType,
                  durationMinutes: recipe.durationMinutes,
                  servings: recipe.servings,
                ),
                
                const SizedBox(height: 16),
                
                // Tabs
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.black,
                  tabs: const [
                    Tab(text: 'Summary'),
                    Tab(text: 'Ingredients'),
                    Tab(text: 'Direction'),
                  ],
                ),
                
                // Tab Content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Summary Tab
                      RecipeSummary(description: recipe.description),
                      
                      // Ingredients Tab
                      RecipeIngredients(ingredients: recipe.ingredients),
                      
                      // Directions Tab
                      RecipeDirections(directions: recipe.directions),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
