import 'package:flutter/material.dart';

class CustomButtonInactif extends StatelessWidget {
  final String text;
  final Function onPressed;

  const CustomButtonInactif({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

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
