import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;

  const CustomTextInput({
    super.key,
    required this.controller,
    required this.labelText, 
    required int maxLines,
    required int maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.60,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          fillColor: Colors.grey[200],
          filled: true,
        ),
      ),
    );
  }
}


