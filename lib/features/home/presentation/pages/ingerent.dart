import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_app_withai/core/common/cubits/app_users/app_user_cubit.dart';
import 'package:recipe_app_withai/core/entity/recipe_entity.dart';
import 'package:recipe_app_withai/core/theme/app_pallet.dart';
import 'package:recipe_app_withai/features/home/presentation/manager/recipe_bloc.dart';

class Ingredient {
  String? name;
  String? imagePath;

  Ingredient({this.name, this.imagePath});
}
class AddRecipeForm extends StatefulWidget {
  // final Function(RecipeEntity) onSave;

  const AddRecipeForm({super.key});

  @override
  State<AddRecipeForm> createState() => _AddRecipeFormState();
}
class _AddRecipeFormState extends State<AddRecipeForm> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String category = '';
  String description = '';
  int durationMinutes = 0;
  String? imagePath;
  List<Ingredient> ingredientsList = [];
  List<String> ingredients = [];
  Future<void> _pickImage(Function(String) onImagePicked) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      onImagePicked(pickedFile.path);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add your ingredients"),backgroundColor: AppPallet.whiteColor,),
    body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(
              children: [
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
                        : const Center(child: Text("Tap to add recipe image")),
                  ),
                ),
                const SizedBox(height: 20),

                TextFormField(

                  decoration: const InputDecoration(labelText: "Title",),
                  onSaved: (value) => title = value ?? '',
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Category"),
                  onSaved: (value) => category = value ?? '',
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Description"),
                  onSaved: (value) => description = value ?? '',
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Duration (minutes)"),
                  keyboardType: TextInputType.number,
                  onSaved: (value) =>
                  durationMinutes = int.tryParse(value ?? '0') ?? 0,
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Ingredients",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: ingredientsList.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            // صورة المكوّن
                            GestureDetector(
                              onTap: () => _pickImage((path) {
                                setState(() {
                                  ingredientsList[index].imagePath = path;
                                });
                              }),
                              child: Container(
                                width: 60,
                                height: 60,
                                margin: const EdgeInsets.only(right: 8, top: 8),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ingredientsList[index].imagePath != null
                                    ? Image.file(
                                  File(ingredientsList[index].imagePath!),
                                  fit: BoxFit.cover,
                                )
                                    : const Icon(Icons.add_a_photo, size: 20),
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                    labelText: "Ingredient name"),
                                onChanged: (value) =>
                                ingredientsList[index].name = value,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  ingredientsList.removeAt(index);
                                });
                              },
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPallet.mainColor
                      ),
                      onPressed: () {
                        setState(() {
                          ingredientsList.add(Ingredient());
                        });
                      },
                      icon: const Icon(Icons.add,color:AppPallet.whiteColor ,),
                      label: const Text("Add Ingredient",style: TextStyle(color: AppPallet.whiteColor),),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:AppPallet.mainColor ,
                  ),
                  onPressed: () {
                    // _formKey.currentState?.save();
                    if(_formKey.currentState!.validate() && imagePath != null){
                      final posterId = (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
                      context.read<RecipeBloc>().add(RecipeUpload(posterId, title, category, description, ingredients, durationMinutes,File(imagePath!) , true));
                    }
                    // widget.onSave(
                    // RecipeEntity(
                    //   title: title,
                    //   category: category,
                    //   ingredientsCount: ingredientsList.length,
                    //   description: description,
                    //   ingredients: ingredientsList
                    //       .map((e) => e.name ?? "")
                    //       .where((e) => e.isNotEmpty)
                    //       .toList(),
                    //   durationMinutes: durationMinutes,
                    //   imagePath: imagePath,
                    // ),
                    // );
                  },
                  child: const Text("Save",style: TextStyle(color: AppPallet.whiteColor),),
                ),
              ],
            ),
          ),
      ),
    ),
    );
  }
}