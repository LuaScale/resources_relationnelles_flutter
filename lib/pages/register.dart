import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:resources_relationnelles_flutter/widgets/text_input.dart';
import 'package:resources_relationnelles_flutter/widgets/password_input.dart';
import 'package:resources_relationnelles_flutter/widgets/custom_button.dart';
import 'package:resources_relationnelles_flutter/widgets/image_display.dart'; // Import du nouveau widget
import 'package:resources_relationnelles_flutter/widgets/custom_appbar.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inscription',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const RegistrationPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  RegistrationPageState createState() => RegistrationPageState();
}

class RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isObscure = true;

  void _toggleObscure() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

    void _validateAndSubmit() async {
    final String firstname = _firstnameController.text.trim();
    final String lastname = _lastnameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;

    if (firstname.isEmpty || lastname.isEmpty) {
      _showErrorDialog('Veuillez entrer votre nom et prénom.');
      return;
    }

    if (!_isEmailValid(email)) {
      _showErrorDialog('Email invalide.');
      return;
    }

    if (!_isPasswordValid(password)) {
      _showErrorDialog('Le mot de passe doit contenir au moins 12 caractères, une majuscule, une minuscule et un caractère spécial.');
      return;
    }

    // Envoi des données à l'API
    const String apiUrl = 'http://82.66.110.4:8000/api/createAccount';
    String? cle = dotenv.env['API_KEY'];
    final response = await http.post(
        headers: {
        'X-API-Key': '$cle',
        HttpHeaders.contentTypeHeader : "application/json"
        },
        Uri.parse(apiUrl),
      body: jsonEncode(<String, String>{
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'plainPassword': password,
      }),);
    if (response.statusCode == 201) {
      // Envoi du mail avec le token de confirmation
      // Cette partie doit être implémentée en utilisant un service d'envoi de mails comme SendGrid, Mailgun, etc.
      _showErrorDialog('Inscription réussie. Veuillez vérifier votre email pour confirmer votre inscription.');
    } else {
      _showErrorDialog('Erreur lors de l\'inscription. Veuillez réessayer.');
    }
    _firstnameController.clear();
    _lastnameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
  }

  bool _isEmailValid(String email) {
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool _isPasswordValid(String password) {
    final RegExp passwordRegex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{12,}$');
    return passwordRegex.hasMatch(password);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Information'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
          title: Text('Inscription'),
      ),
      backgroundColor: const Color(0xFF03989E),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ImageDisplay(imagePath: 'lib/assets/images/ReSource.png', height: 200), // Utilisation du nouveau widget
                CustomTextInput(controller: _firstnameController, labelText: 'Prénom', maxLines: 1, maxLength: 100),
                const SizedBox(height: 10),
                CustomTextInput(controller: _lastnameController, labelText: 'Nom', maxLines: 1, maxLength: 1000),
                const SizedBox(height: 10),
                CustomTextInput(controller: _emailController, labelText: 'Email', maxLines: 1, maxLength: 1000),
                const SizedBox(height: 10),
                PasswordInput(controller: _passwordController, obscureText: _isObscure, onPressed: _toggleObscure),
                const SizedBox(height: 10),
                PasswordInput(controller: _confirmPasswordController, obscureText: _isObscure, onPressed: _toggleObscure),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomButton(text: 'Annuler', onPressed: _resetFields),
                    CustomButton(text: 'Valider', onPressed: _validateAndSubmit),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _resetFields() {
    // Clear all fields
    _firstnameController.clear();
    _lastnameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
  }
}
