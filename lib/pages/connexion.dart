import 'package:flutter/material.dart';
import 'forgot_password.dart';
import 'register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Authentication',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthenticationPage(),
    );
  }
}

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion'),
        backgroundColor: const Color(0xFFFFBD59), // Couleur #ffbd59 pour le fond d'écran de la navbar
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xff03989e), // Couleur verte pour le fond d'écran du body
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
              const SizedBox(height: 20.0),   
              // Logo goes here
              Image.asset('../assets/image/ReSource.png', width: 100, height: 100),
              const SizedBox(height: 20.0),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white), // Couleur du texte
                  decoration: InputDecoration(
                    hintText: 'Email',
                    filled: true,
                    fillColor: Colors.grey[100], // Gris foncé
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)), // Couleur du texte d'indication
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white), // Couleur du texte
                  decoration: InputDecoration(
                    hintText: 'Mot de passe',
                    filled: true,
                    fillColor: Colors.grey[100], // Gris foncé
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)), // Couleur du texte d'indication
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        // Action à effectuer en cas d'annulation
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFBD59), // Couleur #ffbd59
                      ),
                      child: const Text('Annuler'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Action à effectuer en cas de validation
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFBD59), // Couleur #ffbd59
                      ),
                      child: const Text('Valider'),
                    ),
                  ],
                ),
                 const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                        );
                      },
                      child: const Text(
                        'Mot de passe oublié ?',
                        style: TextStyle(color: Color(0xFFFFBD59)),
                        ),
                    ),
                    const SizedBox(width: 10), // Espacement entre les deux liens
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegistrationPage()),
                        );
                      },
                      child: const Text(
                        'Pas encore inscrit ?',
                        style: TextStyle(color: Color(0xFFFFBD59)),
                        ),
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
