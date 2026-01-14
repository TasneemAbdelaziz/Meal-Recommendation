import 'package:flutter/material.dart';

class CustomTextFeild extends StatelessWidget {
   String? hint;
   String labelText;
   TextEditingController controller;
   bool? obscureText;
   CustomTextFeild({
    super.key,
    required this.controller,
    required this.labelText,
    this.obscureText,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText??false,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
      ),
    );
  }
}