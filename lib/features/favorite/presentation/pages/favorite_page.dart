import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app_withai/features/add_recipe/data/models/recipe_model.dart';
import 'package:recipe_app_withai/features/favorite/presentation/bloc/favorites_bloc.dart';
import 'package:recipe_app_withai/features/favorite/presentation/bloc/favorites_event.dart';
import 'package:recipe_app_withai/features/favorite/presentation/bloc/favorites_state.dart';
import 'package:recipe_app_withai/features/favorite/presentation/widgets/favorite_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});
  static const String routeName = "FavoritesPage";

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {


  Future<List<RecipeModel>> _fetchRecipesByIds(Set<String> ids) async {
    if (ids.isEmpty) return [];

    final res = await Supabase.instance.client
        .from('recipes')
        .select()
        .inFilter('id', ids.toList())
        .order('updated_at', ascending: false);

    return (res as List<dynamic>)
        .map((e) => RecipeModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  String? _userId;

  @override
  void initState() {
    super.initState();

    _userId = Supabase.instance.client.auth.currentUser?.id;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_userId != null) {
        context.read<FavoritesBloc>().add(FavoritesStarted(_userId!));
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    // print('Has FavoritesBloc? ${hasBloc(context)}');

    final userId = _userId;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: userId == null
          ? const Center(child: Text('Please login'))
          : BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          final favIds = state.favoriteIds;

          return RefreshIndicator(
            onRefresh: () async {
              context.read<FavoritesBloc>().add(FavoritesRefreshed(userId));
            },
            child: () {
              // ✅ (A) loading/initial: لازم Scrollable
              if (state.status == FavoritesStatus.initial ||
                  state.status == FavoritesStatus.loading) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 160),
                    Center(child: CircularProgressIndicator()),
                  ],
                );
              }

              // ✅ (B) ready + ids empty => No favorites
              if (state.status == FavoritesStatus.ready && favIds.isEmpty) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 160),
                    Center(child: Text('No favorites yet')),
                  ],
                );
              }

              // ✅ (C) هنا بس نعمل fetch recipes
              return FutureBuilder<List<RecipeModel>>(
                future: _fetchRecipesByIds(favIds),
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: 160),
                        Center(child: CircularProgressIndicator()),
                      ],
                    );
                  }

                  if (snap.hasError) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        const SizedBox(height: 160),
                        Center(child: Text('Error: ${snap.error}')),
                      ],
                    );
                  }

                  final recipes = snap.data ?? const <RecipeModel>[];
                  if (recipes.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: 160),
                        Center(child: Text('No favorites yet')),
                      ],
                    );
                  }
                  return ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(12),
                    itemCount: recipes.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final r = recipes[i];
                      final isFav = favIds.contains(r.id);

                      return MealCard(imageUrl:  r.imagePath, tag: r.description, title: r.title, ingredientsCount: r.ingredients.length, timeText: r.durationMinutes.toString(), rating: r.durationMinutes, isFavorite: isFav, onFavoriteTap: () {
                          context.read<FavoritesBloc>().add(
                            FavoriteToggled(userId: userId, recipeId: r.id),
                          );
                        },
                      );
                      //   Card(
                      //   child: ListTile(
                      //     leading: r.imagePath.isEmpty
                      //         ? const Icon(Icons.image)
                      //         : Image.network(
                      //       r.imagePath,
                      //       width: 56,
                      //       height: 56,
                      //       fit: BoxFit.cover,
                      //     ),
                      //     title: Text(r.title),
                      //     subtitle: Text('${r.category} • ${r.durationMinutes} min'),
                      //     trailing: IconButton(
                      //       icon: Icon(
                      //
                      //       // ),
                      //       onPressed: () {
                      //         context.read<FavoritesBloc>().add(
                      //           FavoriteToggled(userId: userId, recipeId: r.id),
                      //         );
                      //       },
                      //     ),
                      //   ),
                      // );
                    },
                  );
                },
              );
            }(),
          );

        },
      ),
    );
  }
}
