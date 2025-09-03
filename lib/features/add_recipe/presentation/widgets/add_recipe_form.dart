import 'package:flutter/material.dart';

class AddRecipeForm extends StatelessWidget {
  TextEditingController controller;
  String labelText;
  TextInputType? keyboardType;
  final String? Function(String?)? validator;
  int? maxLines;


  AddRecipeForm({super.key,required this.controller,required this.labelText,this.keyboardType,this.validator,this.maxLines});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      controller: controller,
      decoration:  InputDecoration(labelText:labelText),
      keyboardType: keyboardType??TextInputType.text,
      validator: validator,
    );
  }
}
