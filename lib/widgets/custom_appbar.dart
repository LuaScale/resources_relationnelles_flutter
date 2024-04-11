import 'package:flutter/material.dart';
import 'package:resources_relationnelles_flutter/pages/ressources/creer_ressource.dart';
import 'package:resources_relationnelles_flutter/pages/utilisateur/profil.dart';
import 'package:resources_relationnelles_flutter/main.dart';
import 'package:resources_relationnelles_flutter/services/get_user.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  final Text? title;

  const CustomAppBar({
    Key? key,
    this.title,
  }) : super(key: key);

  dynamic getUser() async {
    return await fetchUtilisateurByToken();
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUser(), 
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
            var user = snapshot.data;
        if(user == null){
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator()),
          );
        } else {
                          return AppBar(
              backgroundColor: const Color(0xFFFFBD59), // Couleur de fond spécifiée (jaune)
              title: title, // Ajout du titre à l'AppBar
              actions: [
                IconButton(
                  icon: const Icon(Icons.home),
                  onPressed: () {
                          // Naviguer vers la page "accueil"
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MyApp()),
                          );
                        }
                ),
                if(user != false)
                IconButton(
                  icon: const Icon(Icons.favorite),
                  onPressed:  () {
                          // Naviguer vers la page "favoris"
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CreerRessourcePage()),
                          );
                        }
                ),
                IconButton(
                  icon: const Icon(Icons.person),
                  onPressed:  () {
                          // Naviguer vers la page "profil"
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ProfilePage()),
                          );
                        }
                ),
                if(user != false)
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                          // Naviguer vers la page "Créer une ressource"
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CreerRessourcePage()),
                          );
                        }
                ),
              ],
            );
            }
      }
      );
  }
}
