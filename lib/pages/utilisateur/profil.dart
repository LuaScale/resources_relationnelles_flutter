import 'package:flutter/material.dart';
import 'package:resources_relationnelles_flutter/pages/connexion.dart';
import 'package:resources_relationnelles_flutter/pages/register.dart';
import 'package:resources_relationnelles_flutter/pages/ressources/liste_ressources.dart';
import 'package:resources_relationnelles_flutter/services/get_user.dart';
import 'package:resources_relationnelles_flutter/widgets/custom_appbar.dart';
import 'package:resources_relationnelles_flutter/widgets/custom_button.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:resources_relationnelles_flutter/services/secure_storage.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  dynamic getUser() async {
    return await fetchUtilisateurByToken();
  }
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double containerHeight = screenHeight * 0.9; // 90% de la hauteur de l'écran

    void logout() async {
      await SessionManager().destroy();
      final SecureStorage storage = SecureStorage();
      await storage.delteSecureData('token');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ListerRessourcesPage()),
      );
    }
    return FutureBuilder(
      future: getUser(), 
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
        var user = snapshot.data;
        if(user == null){
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator()),
          );
        }
        if(user == false) {
          return Scaffold(
            appBar: const CustomAppBar(
                title: Text('Profil'),
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
              ],
            ),
          ),
          );
        } else{
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
                  radius: 80, // Taille du cercle de l'avatar
                  backgroundImage: AssetImage('lib/assets/images/avatar.png'), // Image de l'avatar
                  ),
                  const SizedBox(height: 20), // Espacement entre l'avatar et les autres éléments
                  _buildProfileItem('Prénom:', user.prenom),
                  _buildProfileItem('Nom:', user.nom),
                  _buildProfileItem('Email:', user.email),
                  const SizedBox(height: 20), // Espacement entre l'email et l'icône favori// Texte "Mes favoris"
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      CustomButton(text: 'Modifier', onPressed: _onModifyPressed),
                      CustomButton(text: 'Deconnexion', onPressed: () => { logout() }),
                      const Padding(padding: EdgeInsets.all(20))
                    ],
                  ) // Espacement entre "Mes favoris" et le bouton "Modifier" // Bouton Modifier avec couleur personnaliséemButton(text: 'Annuler', onPressed: _onCancelPressed), // Appel de la fonction _onCancelPressed lorsque le bouton est pressé
                ],
              ),
            ),
          ),
      );
    }
    });
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
