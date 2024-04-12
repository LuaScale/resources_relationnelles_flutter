import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:resources_relationnelles_flutter/pages/ressources/liste_ressources.dart';
import 'package:resources_relationnelles_flutter/services/secure_storage.dart';
import 'package:resources_relationnelles_flutter/widgets/image_display.dart';
import 'package:resources_relationnelles_flutter/widgets/text_input.dart';
import 'package:resources_relationnelles_flutter/widgets/password_input.dart';
import 'package:resources_relationnelles_flutter/widgets/custom_button.dart';
import 'package:resources_relationnelles_flutter/widgets/custom_appbar.dart';

import '../classes/utilisateur.dart';
import '../services/get_user.dart';

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

  void _toggleObscure() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  Future<void> _authenticate() async {
    String email = _emailController.text;
    String plainPassword = _plainPasswordController.text;

    // Stocker la référence du ScaffoldMessenger.of(context)
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    // Faire la requête HTTP pour récupérer les données de l'API
    String? cle = dotenv.env['API_KEY'];
    final response = await http.post(
      Uri.parse('http://82.66.110.4:8000/auth'),
      headers: {
        'X-API-Key': '$cle',
        HttpHeaders.contentTypeHeader : "application/json"
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': plainPassword,
      }),
    );

    if (response.statusCode == 200) {
      // Authentification réussie, traiter la réponse de l'API si nécessaire
      var jsonResponse = jsonDecode(response.body) as Map;
      await SessionManager().destroy();
      scaffoldMessenger.showSnackBar(snackBarSuccess);
      final SecureStorage storage = SecureStorage();
      await storage.writeSecureData('token', jsonResponse.values.elementAt(0));
      dynamic user = await fetchUtilisateurByToken();
      if(user == false){
        throw Exception("Impossible de récupérer l'utilisateur");
      }
      await SessionManager().set('user', user);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ListerRessourcesPage()),
      );
    } else {
      // Authentification échouée, afficher un message d'erreur ou effectuer une action appropriée
      scaffoldMessenger.showSnackBar(snackBarError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
          title: Text('Ressources'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xff03989e),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 20.0),
                const ImageDisplay(imagePath: 'lib/assets/images/ReSource.png', height: 200), // Affichage de l'image
                const SizedBox(height: 10),
                CustomTextInput(controller: _emailController, labelText: 'Email', maxLines: 1, maxLength: 50),
                const SizedBox(height: 10),
                PasswordInput(controller: _plainPasswordController, obscureText: _isObscure, onPressed: _toggleObscure),
                const SizedBox(height: 20.0),
                CustomButton(
                  text: 'Connexion',
                  onPressed: _authenticate,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
