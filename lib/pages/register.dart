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
  final TextEditingController _plainPasswordController = TextEditingController();
  final TextEditingController _confirmplainPasswordController = TextEditingController();

  bool _isObscure = true;

  void _validateAndSubmit() async {
    // Validation des champs
    String firstname = _firstnameController.text;
    String lastname = _lastnameController.text;
    String email = _emailController.text;
    String plainPassword = _plainPasswordController.text;
    String confirmplainPassword = _confirmplainPasswordController.text;

    // Vérification de la validité du mail
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _showDialog('Email invalide');
      return;
    }

    // Vérification de la force du mot de passe
    if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$').hasMatch(plainPassword)) {
      _showDialog('Le mot de passe doit contenir au moins 8 caractères avec au moins une minuscule, une majuscule, un chiffre et un caractère spécial.');
      return;
    }

    // Vérification de la correspondance des mots de passe
    if (plainPassword != confirmplainPassword) {
      _showDialog('Les mots de passe ne correspondent pas');
      return;
    }

    // Envoi des données à l'API
    const String apiUrl = 'http://82.66.110.4:8000/api/createAccount';
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'plainPassword': plainPassword,
      },
    );

    if (response.statusCode == 200) {
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
    _plainPasswordController.clear();
    _confirmplainPasswordController.clear();
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
                backgroundColor: Colors.yellow,
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
      ),
      backgroundColor: const Color(0xFF03989E),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/assets/images/ReSource.png', 
                fit: BoxFit.cover,
                height: 200, // Définir une hauteur fixe pour l'image
              ),
              SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                child: TextField(
                  controller: _firstnameController,
                  decoration: InputDecoration(
                    labelText: 'firstname',
                    fillColor: Colors.grey[200],
                    filled: true,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                child: TextField(
                  controller: _lastnameController,
                  decoration: InputDecoration(
                    labelText: 'lastname',
                    fillColor: Colors.grey[200],
                    filled: true,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    fillColor: Colors.grey[200],
                    filled: true,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
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
              SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                child: TextField(
                  controller: _confirmplainPasswordController,
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
              SizedBox(height: 20),
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
                      _plainPasswordController.clear();
                      _confirmplainPasswordController.clear();
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
