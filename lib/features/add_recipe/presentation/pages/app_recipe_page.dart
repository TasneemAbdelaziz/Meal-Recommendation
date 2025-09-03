import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_app_withai/core/common/cubits/app_users/app_user_cubit.dart';
import 'package:recipe_app_withai/core/theme/app_pallet.dart';
import 'package:recipe_app_withai/features/add_recipe/domian/entities/ingredient.dart';
import 'package:recipe_app_withai/features/add_recipe/presentation/manager/recipe_bloc.dart';
import 'package:recipe_app_withai/features/add_recipe/presentation/widgets/add_recipe_form.dart';
import 'package:recipe_app_withai/translation/icon_nav_bar.dart';


class AddRecipePage extends StatefulWidget {
  static const String routeName="AddRecipePage";
  const AddRecipePage({super.key});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}
class _AddRecipePageState extends State<AddRecipePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();

  String? imagePath;
  List<Ingredient> ingredientsList = [];
  List<TextEditingController> ingredientControllers = [];
  List<String?> ingredientImagePaths = [];

  Future<void> _pickImage(Function(String) onImagePicked) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      onImagePicked(pickedFile.path);
    }
  }

  void _addIngredient() {
    setState(() {
      ingredientControllers.add(TextEditingController());
      ingredientImagePaths.add(null);
      ingredientsList.add(Ingredient(name: ''));
    });
  }

  void _removeIngredient(int index) {
    setState(() {
      ingredientControllers.removeAt(index);
      ingredientImagePaths.removeAt(index);
      ingredientsList.removeAt(index);
    });
  }

  void _updateIngredientName(int index, String name) {
    setState(() {
      ingredientsList[index] = ingredientsList[index].copyWith(name: name);
    });
  }

  void _updateIngredientImage(int index, String imagePath) {
    setState(() {
      ingredientsList[index] = ingredientsList[index].copyWith(imagePath: imagePath);
      ingredientImagePaths[index] = imagePath;
    });
  }

  void _saveRecipe() {
    if (_formKey.currentState!.validate() && imagePath != null) {
      print('💾 Save button pressed');

      final validIngredients = ingredientsList
          .where((ingredient) => ingredient.name.isNotEmpty)
          .toList();

      print('📋 Valid ingredients: ${validIngredients.map((i) => i.name).toList()}');

      final appUserState = context.read<AppUserCubit>().state;
      if (appUserState is AppUserLoggedIn) {
        final posterId = appUserState.user.id;
        print('👤 Poster ID: $posterId');
        showDialog(
          context: context,
          barrierDismissible: false, // Prevent closing by tapping outside
          builder: (context) => const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Uploading recipe...'),
              ],
            ),
          ),
        );
        print('🚀 Sending RecipeUpload event...');
        context.read<RecipeBloc>().add(RecipeUpload(
          posterId: posterId,
          title: _titleController.text,
          category: _categoryController.text,
          description: _descriptionController.text,
          ingredients: validIngredients,
          durationMinutes: int.tryParse(_durationController.text) ?? 0,
          image: File(imagePath!),
          isFavorite: false,
        ));

        // Navigator.pop(context);
      } else {
        print('❌ User not logged in properly');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in first')),
        );
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    for (var controller in ingredientControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecipeBloc, RecipeState>(
      listener: (context, state) {
        if (state is RecipeSuccess) {
          // Close the loading dialog
          Navigator.pop(context);

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Recipe uploaded successfully!')),
          );

          // Navigate back to home
          Navigator.pop(context, true); // Return true to indicate success
        } else if (state is RecipeFailure) {
          // Close the loading dialog
          Navigator.pop(context);

          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Upload failed: ${state.error}')),
          );
        }
  },
  child: Scaffold(
      appBar: AppBar(
        title: const Text("Add New Recipe"),
        backgroundColor: AppPallet.whiteColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // صورة الوصفة الرئيسية
                GestureDetector(
                  onTap: () => _pickImage((path) {
                    setState(() {
                      imagePath = path;
                    });
                  }),
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo, size: 40),
                          SizedBox(height: 8),
                          Text("Tap to add recipe image"),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                AddRecipeForm(
                  controller: _titleController,
                  labelText: "Title",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                AddRecipeForm(
                  controller: _categoryController,
                  labelText: "Category",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a category';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                AddRecipeForm(
                  controller: _descriptionController,
                  labelText: "Description",
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                AddRecipeForm(
                  controller: _durationController,
                  labelText: "Duration (minutes)",
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
                ),

                const SizedBox(height: 20),
                // المكونات
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Ingredients",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: ingredientsList.length,
                      itemBuilder: (context, index) {
                        if (index >= ingredientControllers.length) {
                          ingredientControllers.add(TextEditingController());
                        }
                        if (index >= ingredientImagePaths.length) {
                          ingredientImagePaths.add(null);
                        }

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              // صورة المكوّن
                              GestureDetector(
                                onTap: () => _pickImage((path) {
                                  _updateIngredientImage(index, path);
                                }),
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  margin: const EdgeInsets.only(right: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ingredientImagePaths[index] != null
                                      ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      File(ingredientImagePaths[index]!),
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                      : const Icon(Icons.add_a_photo, size: 24),
                                ),
                              ),

                              // اسم المكون
                              Expanded(
                                child: TextFormField(
                                  controller: ingredientControllers[index],
                                  decoration: const InputDecoration(
                                    labelText: "Ingredient name",
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    _updateIngredientName(index, value);
                                  },
                                ),
                              ),

                              // زر الحذف
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _removeIngredient(index),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPallet.mainColor,
                      ),
                      onPressed: _addIngredient,
                      icon: const Icon(Icons.add, color: AppPallet.whiteColor),
                      label: const Text(
                        "Add Ingredient",
                        style: TextStyle(color: AppPallet.whiteColor),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // زر الحفظ
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppPallet.mainColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: _saveRecipe,
                    child: const Text(
                      "Save Recipe",
                      style: TextStyle(
                        color: AppPallet.whiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
);
  }
}