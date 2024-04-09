import 'package:flutter/material.dart';
import 'pages/connexion.dart';
import 'pages/register.dart';
import 'pages/ressources/liste_ressources.dart';
import 'pages/ressources/creer_ressource.dart';
import 'package:resources_relationnelles_flutter/widgets/custom_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFFBD59)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '(RE)SOURCE RELATIONNELLES - Accueil'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, Key? key}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFBD59),
        title: Text(widget.title),
      ),
      backgroundColor: const Color(0xFF03989E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomButton(
              text: 'Se connecter',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthenticationPage()),
                );
              },
            ),
            const SizedBox(height: 20,),
            CustomButton(
              text: 'S\'inscrire',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegistrationPage()),
                );
              },
            ),
            const SizedBox(height: 20,),
            CustomButton(
              text: 'Ne pas se connecter',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ListerRessourcesPage()),
                );
              },
            ),
            const SizedBox(height: 20,),
            CustomButton(
              text: 'Ajouter une ressource',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreerRessourcePage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


