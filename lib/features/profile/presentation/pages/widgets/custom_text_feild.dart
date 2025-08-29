import 'package:flutter/material.dart';

class CustomTextFeild extends StatefulWidget {
  final String? hint;
  final String label;
  const CustomTextFeild({
    super.key,
    required this.label,
    this.hint,
  });

  @override
  State<CustomTextFeild> createState() => _CustomTextFeildState();
}

class _CustomTextFeildState extends State<CustomTextFeild> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}