import 'package:flutter/material.dart';

class CustomButtonInactif extends StatelessWidget {
  final String text;
  final Function onPressed;

  const CustomButtonInactif({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF03989e),
      ),
      onPressed: () => onPressed(),
      child: Text(text),
    );
  }
}
