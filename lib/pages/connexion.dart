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
      title: 'Authentication',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthenticationPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _plainPasswordController = TextEditingController();
  bool _isObscure = true;
  final snackBarSuccess = const SnackBar(content: Text('Vous êtes connecté !'));
  final snackBarError = const SnackBar(content: Text('Une erreur est survenue !'));

  Future<void> _authenticate() async {
    String email = _emailController.text;
    String plainPassword = _plainPasswordController.text;

    // Faire la requête HTTP pour récupérer les données de l'API
    final response = await http.post(
      Uri.parse('http://82.66.110.4:8000/auth'),
      headers: {
        'X-API-Key': 'test',
        HttpHeaders.contentTypeHeader : "application/json"
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': plainPassword,
      }),
    );

    if (response.statusCode == 200) {
      // Authentification réussie, traiter la réponse de l'API si nécessaire
      ScaffoldMessenger.of(context).showSnackBar(snackBarSuccess);
      var jsonResponse = jsonDecode(response.body) as Map;
      final token = jsonResponse.values.elementAt(0);
    } else {
      // Authentification échouée, afficher un message d'erreur ou effectuer une action appropriée
      ScaffoldMessenger.of(context).showSnackBar(snackBarError);
    }
  }

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion'),
        backgroundColor: const Color(0xFFFFBD59),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xff03989e),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 20.0),
                Image.asset(
                  'lib/assets/images/ReSource.png',
                  fit: BoxFit.cover,
                  height: 200,
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
                  controller: _plainPasswordController,
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
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: _authenticate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFBD59),
                      ),
                      child: const Text('Connexion'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
