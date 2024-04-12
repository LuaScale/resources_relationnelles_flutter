import 'package:flutter/material.dart';
import 'package:resources_relationnelles_flutter/pages/ressources/creer_ressource.dart';

import '../../widgets/custom_appbar.dart';
import 'lister_commentaires.dart';
import 'lister_ressources_restreintes.dart';

class PanelModeration extends StatelessWidget {
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
            Text('Accepter des ressources', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            FloatingActionButton(
              heroTag: 'ressource',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListerRessourcesRestreintesPage()),
                );
              },
              child: Icon(Icons.check),
              tooltip: 'Accepter des ressources',
              backgroundColor: Colors.green,
            ),
            SizedBox(height: 20),
            Text('Modérer les commentaires', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            FloatingActionButton(
              heroTag: 'comment',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListerCommentairesPage()), // Remplacez par la page de modification
                );
              },
              child: Icon(Icons.comment_outlined),
              tooltip: 'Voir les commentaires',
              backgroundColor: const Color(0xFF03989E),
            ),
          ],
        ),
      ),
    );
  }
}