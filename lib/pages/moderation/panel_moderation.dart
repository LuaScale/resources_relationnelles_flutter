import 'package:flutter/material.dart';

import '../../widgets/custom_appbar.dart';
import 'lister_commentaires.dart';
import 'lister_ressources_restreintes.dart';

class PanelModeration extends StatelessWidget {
  const PanelModeration({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: Text('Moderation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Accepter des ressources', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            FloatingActionButton(
              heroTag: 'ressource',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ListerRessourcesRestreintesPage()),
                );
              },
              tooltip: 'Accepter des ressources',
              backgroundColor: Colors.green,
              child: const Icon(Icons.check),
            ),
            const SizedBox(height: 20),
            const Text('Modérer les commentaires', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            FloatingActionButton(
              heroTag: 'comment',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ListerCommentairesPage()), // Remplacez par la page de modification
                );
              },
              tooltip: 'Voir les commentaires',
              backgroundColor: const Color(0xFF03989E),
              child: const Icon(Icons.comment_outlined),
            ),
          ],
        ),
      ),
    );
  }
}