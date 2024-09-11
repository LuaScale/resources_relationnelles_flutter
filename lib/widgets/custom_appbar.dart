import 'package:flutter/material.dart';
import 'package:resources_relationnelles_flutter/pages/admin/admin_panel.dart';
import 'package:resources_relationnelles_flutter/pages/admin/admin_stats.dart';
import 'package:resources_relationnelles_flutter/pages/favorite/liste_favorites.dart';
import 'package:resources_relationnelles_flutter/pages/landing_page.dart';
import 'package:resources_relationnelles_flutter/pages/moderation/panel_moderation.dart';
import 'package:resources_relationnelles_flutter/pages/ressources/creer_ressource.dart';
import 'package:resources_relationnelles_flutter/pages/utilisateur/profil.dart';
import 'package:resources_relationnelles_flutter/services/get_user.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  final Text? title;

  const CustomAppBar({
    super.key,
    this.title,
  });

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
                if(user != false && user.roles.contains('ROLE_ADMIN'))
                IconButton(
                  icon: const Icon(Icons.query_stats),
                  onPressed:  () {
                          // Naviguer vers la page "Stats"
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AdminStats()),
                          );
                        }
                ),
                if(user != false && user.roles.contains('ROLE_ADMIN'))
                IconButton(
                  icon: const Icon(Icons.admin_panel_settings),
                  onPressed:  () {
                          // Naviguer vers la page "AdminPanelPage"
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AdminPanelPage()),
                          );
                        }
                ),
                if(user != false && (user.roles.contains('ROLE_ADMIN') || user.roles.contains('ROLE_MODERATOR')))
                IconButton(
                  icon: const Icon(Icons.remove_moderator_outlined),
                  onPressed:  () {
                          // Naviguer vers la page "profil"
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PanelModeration()),
                          );
                        }
                ),
                IconButton(
                  icon: const Icon(Icons.home),
                  onPressed: () {
                          // Naviguer vers la page "accueil"
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LandingPage()),
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
                            MaterialPageRoute(builder: (context) => const ListerFavoriesPage()),
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
