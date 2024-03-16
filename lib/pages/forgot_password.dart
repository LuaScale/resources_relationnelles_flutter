import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mot de passe oublié'),
        backgroundColor: const Color(0xFFFFBD59), // Couleur #ffbd59 pour le fond d'écran de la navbar
      ),
      backgroundColor: const Color(0xff03989e), // Couleur de fond #03989e
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Entrez votre e-mail',
                  labelText: 'E-mail',                   
                  filled: true,
                  fillColor: Colors.grey[100], // Gris foncé
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)), // Couleur du texte d'indication
                  border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                    ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Action à effectuer lorsque le bouton est appuyé
                  // Envoyer l'e-mail de récupération du mot de passe
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:  Color(0xFFFFBD59), // Couleur du bouton #ffbd59
                ),
                child: Text('Envoyer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
