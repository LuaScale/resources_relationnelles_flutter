import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:resources_relationnelles_flutter/widgets/text_input.dart';
import 'package:resources_relationnelles_flutter/widgets/password_input.dart';
import 'package:resources_relationnelles_flutter/widgets/custom_button.dart';
import 'package:resources_relationnelles_flutter/widgets/custom_button_inactive.dart'; // Import du widget CustomButtonInactive
import 'package:resources_relationnelles_flutter/widgets/image_display.dart'; // Import du widget ImageDisplay
import 'package:resources_relationnelles_flutter/widgets/custom_appbar.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  const RegistrationPage({super.key});

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
  bool _isPolicyAccepted = false; // Nouvelle variable pour suivre l'état de la checkbox

  void _toggleObscure() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  void _validateAndSubmit() async {
    final String firstname = _firstnameController.text.trim();
    final String lastname = _lastnameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    // Validation des champs
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

    if (password != _confirmPasswordController.text) {
      _showErrorDialog('Les mots de passe ne correspondent pas.');
      return;
    }

    if (!_isPolicyAccepted) {
      _showErrorDialog('Vous devez accepter la politique de confidentialité.');
      return;
    }

    // Envoi des données à l'API
    const String apiUrl = 'http://82.66.110.4:8000/api/createAccount';
    String? cle = dotenv.env['API_KEY'];
    final response = await http.post(
      headers: {
        'X-API-Key': '$cle',
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      Uri.parse(apiUrl),
      body: jsonEncode(<String, String>{
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'plainPassword': password,
      }),
    );

    if (response.statusCode == 201) {
      _showErrorDialog('Inscription réussie. Veuillez vérifier votre email pour confirmer votre inscription.');
    } else {
      _showErrorDialog('Erreur lors de l\'inscription. Veuillez réessayer.');
    }

    // Effacement des champs
    _resetFields();
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
      appBar: const CustomAppBar(title: Text('Inscription')),
      backgroundColor: const Color(0xFF03989E),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ImageDisplay(imagePath: 'lib/assets/images/ReSource.png', height: 150),
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
                // Ajout de la checkbox et du texte
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: _isPolicyAccepted,
                          onChanged: (bool? value) {
                            setState(() {
                              _isPolicyAccepted = value ?? false;
                            });
                          },
                        ),
                        const Flexible(
                          child: Text(
                            'En cochant la case, vous acceptez la politique de confidentialité.',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center, // Centre le texte
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomButton(text: 'Annuler', onPressed: _resetFields),
                    // Utilisation du widget CustomButton ou CustomButtonInactive selon l'état de la checkbox
                    _isPolicyAccepted
                        ? CustomButton(text: 'Valider', onPressed: _validateAndSubmit)
                        : CustomButtonInactif (text: 'Valider', onPressed: _resetFields),
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
    // Effacement de tous les champs
    _firstnameController.clear();
    _lastnameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
  }
}
