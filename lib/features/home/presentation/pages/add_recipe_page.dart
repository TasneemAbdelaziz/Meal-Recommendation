import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../cards/recipe_card.dart';
import 'package:recipe_app_withai/features/home/domain/recipe_entity.dart';
import 'package:recipe_app_withai/features/home/domain/recipe_repository.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';

class AddRecipePage extends StatefulWidget {
  static const routeName = "/add-recipe";

  const AddRecipePage({super.key});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final List<RecipeEntity> recipes = [];
  bool showForm = false;

  void _addRecipe(RecipeEntity recipe) async {
    try {
      // Get the repository from the HomeBloc
      final homeBloc = context.read<HomeBloc>();
      final repository = homeBloc.repository;

      // Add to Supabase
      await repository.addRecipeRemote(recipe);

      setState(() {
        recipes.add(recipe);
        showForm = false;
      });

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Recipe added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add recipe: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Load existing recipes
    context.read<HomeBloc>().add(LoadAllRecipesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Add your ingredients")),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    if (state is HomeLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is HomeLoaded) {
                      if (state.recipes.isEmpty) {
                        return const Center(child: Text("No recipes yet"));
                      }
                      return ListView.builder(
                        itemCount: state.recipes.length,
                        itemBuilder: (context, index) {
                          final recipe = state.recipes[index];
                          return RecipeCard(recipe: recipe);
                        },
                      );
                    } else if (state is HomeError) {
                      return Center(child: Text(state.message));
                    }
                    return const Center(child: Text("No recipes yet"));
                  },
                ),
              ),
              if (showForm)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AddRecipeForm(onSave: _addRecipe),
                ),
              const SizedBox(height: 70),
            ],
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  showForm = !showForm;
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "enter your ingredientes and your goal",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        showForm ? Icons.arrow_drop_down : Icons.arrow_forward,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddRecipeForm extends StatefulWidget {
  final Function(RecipeEntity) onSave;

  const AddRecipeForm({super.key, required this.onSave});

  @override
  State<AddRecipeForm> createState() => _AddRecipeFormState();
}

class _AddRecipeFormState extends State<AddRecipeForm> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String category = '';
  int ingredientsCount = 0;
  String description = '';
  String ingredientsText = '';
  int durationMinutes = 0;
  String? imagePath;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: imagePath != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(imagePath!),
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    )
                  : const Center(
                      child: Text("Tap to add an image"),
                    ),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            decoration: const InputDecoration(labelText: "Title"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
            onSaved: (value) => title = value ?? '',
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: "Category"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a category';
              }
              return null;
            },
            onSaved: (value) => category = value ?? '',
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: "Ingredients Count"),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter ingredients count';
              }
              if (int.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
            onSaved: (value) =>
                ingredientsCount = int.tryParse(value ?? '0') ?? 0,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: "Description"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
            onSaved: (value) => description = value ?? '',
          ),
          TextFormField(
            decoration: const InputDecoration(
                labelText: "Ingredients (comma separated)"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter ingredients';
              }
              return null;
            },
            onSaved: (value) => ingredientsText = value ?? '',
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: "Duration (minutes)"),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter duration';
              }
              if (int.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
            onSaved: (value) =>
                durationMinutes = int.tryParse(value ?? '0') ?? 0,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState?.save();
                widget.onSave(
                  RecipeEntity(
                    title: title,
                    category: category,
                    ingredientsCount: ingredientsCount,
                    description: description,
                    ingredients: ingredientsText
                        .split(",")
                        .map((e) => e.trim())
                        .toList(),
                    durationMinutes: durationMinutes,
                    imagePath: imagePath,
                  ),
                );
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
