import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

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
      debugShowCheckedModeBanner: false, // Retirer le bandeau de débug en haut à droite
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

  void _validateAndSubmit() async {
    // Validation des champs
    String firstname = _firstnameController.text;
    String lastname = _lastnameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    // Vérification de la validité du mail
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _showDialog('Email invalide');
      return;
    }

    // Vérification de la force du mot de passe
    if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$').hasMatch(password)) {
      _showDialog('Le mot de passe doit contenir au moins 8 caractères avec au moins une minuscule, une majuscule, un chiffre et un caractère spécial.');
      return;
    }

    // Vérification de la correspondance des mots de passe
    if (password != confirmPassword) {
      _showDialog('Les mots de passe ne correspondent pas');
      return;
    }

    // Envoi des données à l'API
    const String apiUrl = 'http://82.66.110.4:8000/api/createAccount';
    final response = await http.post(
      headers: {
        'X-API-Key': 'test',
        HttpHeaders.contentTypeHeader : "application/json"
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
      // Envoi du mail avec le token de confirmation
      // Cette partie doit être implémentée en utilisant un service d'envoi de mails comme SendGrid, Mailgun, etc.
      _showDialog('Inscription réussie. Veuillez vérifier votre email pour confirmer votre inscription.');
    } else {
      _showDialog('Erreur lors de l\'inscription. Veuillez réessayer.');
    }

    // Réinitialisation des champs après envoi
    _firstnameController.clear();
    _lastnameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Message'),
          content: Text(message),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:  const Color(0xFFFFBD59),
              ),
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
      appBar: AppBar(
        title: const Text('Inscription'),
        backgroundColor: const Color(0xFFFFBD59), // Définir la couleur de l'AppBar
      ),
      backgroundColor: const Color(0xFF03989E),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/assets/images/ReSource.png', 
                fit: BoxFit.cover,
                height: 200, // Définir une hauteur fixe pour l'image
              ),
              const SizedBox(height: 0),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.60,
                child: TextField(
                  controller: _firstnameController,
                  decoration: InputDecoration(
                    labelText: 'Prénom',
                    fillColor: Colors.grey[200],
                    filled: true,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.60,
                child: TextField(
                  controller: _lastnameController,
                  decoration: InputDecoration(
                    labelText: 'Nom',
                    fillColor: Colors.grey[200],
                    filled: true,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.60,
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    fillColor: Colors.grey[200],
                    filled: true,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.60,
                child: TextField(
                  controller: _passwordController,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    fillColor: Colors.grey[200],
                    filled: true,
                    suffixIcon: IconButton(
                      icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.60,
                child: TextField(
                  controller: _confirmPasswordController,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    labelText: 'Confirmer le mot de passe',
                    fillColor: Colors.grey[200],
                    filled: true,
                    suffixIcon: IconButton(
                      icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFBD59),
                    ),
                    onPressed: () {
                      // Bouton Annuler
                      _firstnameController.clear();
                      _lastnameController.clear();
                      _emailController.clear();
                      _passwordController.clear();
                      _confirmPasswordController.clear();
                    },
                    child: const Text('Annuler'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFBD59),
                    ),
                    onPressed: _validateAndSubmit,
                    child: const Text('Valider'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
