import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:resources_relationnelles_flutter/pages/connexion.dart';
import 'package:resources_relationnelles_flutter/pages/favorite/liste_favorites.dart';
import 'package:resources_relationnelles_flutter/pages/landing_page.dart';
import 'package:resources_relationnelles_flutter/pages/ressources/liste_ressources.dart';
import 'package:resources_relationnelles_flutter/pages/utilisateur/profil.dart';
import 'package:resources_relationnelles_flutter/services/get_user.dart';
import 'package:resources_relationnelles_flutter/services/secure_storage.dart';

class CustomSidebar extends StatelessWidget {
  const CustomSidebar({super.key});

  Future<dynamic> getUser() async {
    return await fetchUtilisateurByToken();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: getUser(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Return a loading indicator or an empty container while waiting for data
          return Container();
        } else {
          var user = snapshot.data;
          return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Color(0xFF008F77),
                  ),
                  child: Text(
                    '(RE)SOURCES Relationnelles',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
                ListTile(
                  title: const Text('Accueil'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LandingPage()),
                    );
                  },
                ),
                ListTile(
                  title: const Text('Ressources'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ListerRessourcesPage()),
                    );
                  },
                ),
                if (user != null) ...[
                  ListTile(
                    title: const Text('Favoris'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ListerFavoriesPage()),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Profil'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfilePage()),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Déconnexion'),
                    onTap: () async {
                      await SessionManager().destroy();
                      final SecureStorage storage = SecureStorage();
                      await storage.delteSecureData('token');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LandingPage()),
                      );
                    },
                  ),
                ],
                if (user == null) ...[
                  ListTile(
                    title: const Text('Se connecter'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AuthenticationPage()),
                      );
                    },
                  ),
                ],
              ],
            ),
          );
        }
      },
    );
  }
}
