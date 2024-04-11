import 'package:flutter/material.dart';
import 'package:resources_relationnelles_flutter/widgets/custom_appbar.dart';
import 'package:resources_relationnelles_flutter/widgets/custom_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double containerHeight = screenHeight * 0.9; // 90% de la hauteur de l'écran

    return Scaffold(
      appBar: const CustomAppBar(
        title: Text('Profil'),
      ),
      backgroundColor: const Color(0xFF03989E),
      body: Center(
        child: Container(
          width: 600, // Largeur du conteneur
          height: containerHeight, // Hauteur du conteneur
          padding: const EdgeInsets.all(20), // Espacement intérieur
          decoration: BoxDecoration(
            color: Colors.white, // Couleur de fond du conteneur
            borderRadius: BorderRadius.circular(20), // Coins arrondis du conteneur
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
              radius: 50, // Taille du cercle de l'avatar
              backgroundImage: AssetImage('lib/assets/images/avatar.png'), // Image de l'avatar
              ),
              const SizedBox(height: 20), // Espacement entre l'avatar et les autres éléments
              _buildProfileItem('Prénom:', 'VotrePrénom'),
              _buildProfileItem('Nom:', 'VotreNom'),
              _buildProfileItem('Email:', 'email@example.com'),
              const SizedBox(height: 20), // Espacement entre l'email et l'icône favori
              const Icon(Icons.favorite), // Icône favori
              const SizedBox(height: 10), // Espacement entre l'icône favori et le texte "Mes favoris"
              const Text('Mes favoris'), // Texte "Mes favoris"
              const SizedBox(height: 20), // Espacement entre "Mes favoris" et le bouton "Modifier"
              CustomButton(text: 'Modifier', onPressed: _onModifyPressed), // Bouton Modifier avec couleur personnaliséemButton(text: 'Annuler', onPressed: _onCancelPressed), // Appel de la fonction _onCancelPressed lorsque le bouton est pressé
            ],
          ),
        ),
      ),
    );
  }
 Widget _buildProfileItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 10), // Espacement entre le label et la valeur
        Text(
          value,
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }

  void _onModifyPressed() {
    // Action à effectuer lorsque le bouton "Modifier" est pressé
  }
}
