import 'package:flutter/material.dart';

class PasswordInput extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final Function onPressed;

  const PasswordInput({
    Key? key,
    required this.controller,
    required this.obscureText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.60,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: 'Mot de passe',
          fillColor: Colors.grey[200],
          filled: true,
          suffixIcon: IconButton(
            icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
            onPressed: () => onPressed(),
          ),
        ),
      ),
    );
  }
}
