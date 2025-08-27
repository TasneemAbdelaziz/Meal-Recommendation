import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app_withai/features/home/domain/recipe_entity.dart';
import 'package:recipe_app_withai/features/home/domain/recipe_repository.dart';
import 'package:recipe_app_withai/features/home/presentation/cards/recipe_card.dart';
import 'package:recipe_app_withai/features/home/presentation/pages/add_recipe_page.dart';

import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';

class HomePage extends StatefulWidget {
  static const routeName = "/home";

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(LoadSuggestionsEvent());
  }

  void _openRecipeDetails(RecipeEntity recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text(recipe.title)),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                if (recipe.imagePath != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      recipe.imagePath!,
                      fit: BoxFit.cover,
                      height: 200,
                      width: double.infinity,
                    ),
                  ),
                const SizedBox(height: 16),
                Text(recipe.title,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                Text("${recipe.category} • ${recipe.durationMinutes} min"),
                const SizedBox(height: 12),
                Text("Ingredients (${recipe.ingredientsCount}):",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                ...recipe.ingredients.map((ing) => Text("• $ing")).toList(),
                const SizedBox(height: 12),
                Text("Description:",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(recipe.description),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddRecipePage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: "Search recipes...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (value.isEmpty) {
                  context.read<HomeBloc>().add(LoadSuggestionsEvent());
                } else {
                  context.read<HomeBloc>().add(SearchRecipesEvent(value));
                }
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Suggestions",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    context.read<HomeBloc>().add(LoadAllRecipesEvent());
                  },
                  child: const Text("See All"),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<HomeBloc>().add(LoadSuggestionsEvent());
                },
                child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else                   if (state is HomeLoaded) {
                    if (state.recipes.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.restaurant, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              "No recipes found.",
                              style: TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Tap the + button to add your first recipe!",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: state.recipes.length,
                      itemBuilder: (context, index) {
                        final recipe = state.recipes[index];
                        return GestureDetector(
                          onTap: () => _openRecipeDetails(recipe),
                          child: RecipeCard(
                            recipe: recipe,
                            onFavoriteToggle: () {
                              context
                                  .read<HomeBloc>()
                                  .add(ToggleFavoriteEvent(recipe.title));
                            },
                          ),
                        );
                      },
                    );
                  } else if (state is HomeError) {
                    return Center(child: Text(state.message));
                  }
                  return const Center(
                      child: Text("Search results will appear here..."));
                },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
