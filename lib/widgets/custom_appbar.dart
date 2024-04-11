import 'package:flutter/material.dart';
import 'package:resources_relationnelles_flutter/pages/ressources/creer_ressource.dart';
import 'package:resources_relationnelles_flutter/main.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  final Text? title;

  const CustomAppBar({
    Key? key,
    this.title,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blueGrey, // Couleur de fond spécifiée (jaune)
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
                    MaterialPageRoute(builder: (context) => const CreerRessourcePage()),
                  );
                }
        ),
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
