import 'package:flutter/material.dart';


void main() {
  runApp(const Register());
}

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inscription',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RegistrationPage(),
    );
  }
}

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String _errorMessage = '';

  void _validateAndSubmit() {
    final String prenom = _prenomController.text.trim();
    final String nom = _nomController.text.trim();        
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String confirmPassword = _confirmPasswordController.text.trim();

    // Verification que les mots de passe correspondent
    if (password != confirmPassword) {
      setState(() {
        _errorMessage = 'Les mots de passe ne correspondent pas';
      });
      return;
    }

    // You can add more validation here such as checking email format

    // Call your API to register the user
    // Here you would normally make an HTTP request to your API

    // For demonstration purposes, print the values
    print('Prenom: $prenom');
    print('Nom: $nom');
    print('Email: $email');
    print('Password: $password');

    // Reset error message
    setState(() {
      _errorMessage = '';
    });

    // Navigate to next screen or show success message
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff03989e),
      appBar: AppBar(
        title: const Text('Inscription'),
        backgroundColor: const Color(0xFFFFBD59),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 20.0),
              // Logo goes here
              Image.asset('assets/images/ReSource.png', width: 100, height: 100),
              const SizedBox(height: 20.0),
              TextField(
                controller: _prenomController,
                decoration: InputDecoration(
                  hintText: 'prenom',
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: _nomController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  hintText: 'nom',
                ),
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  hintText: 'Email',
                ),
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Mot de passe',
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  hintText: 'Confirmer le mot de passe',
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      // Clear fields
                      _prenomController.clear();
                      _nomController.clear();
                      _emailController.clear();
                      _passwordController.clear();
                      _confirmPasswordController.clear();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFBD59), // Couleur #ffbd59
                    ),
                    child: const Text('Annuler'),
                  ),
                  ElevatedButton(
                    onPressed: _validateAndSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFBD59), // Couleur #ffbd59
                      ),
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