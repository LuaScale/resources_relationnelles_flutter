import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:resources_relationnelles_flutter/classes/ressource.dart';
import 'package:resources_relationnelles_flutter/pages/commentaires/ajout_commentaire.dart';


Future<Ressource> fetchRessources(int id) async {
  String? cle = dotenv.env['API_KEY'];
  final response = await http.get(
    Uri.parse('http://82.66.110.4:8000/api/ressources/$id'),
    headers: {
      'X-API-Key': '$cle',
    },
  );

  if (response.statusCode == 200) {
    return Ressource.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to load ressource');
  }
}

class DetailRessourcePage extends StatefulWidget {
  const DetailRessourcePage({super.key, required this.idRessource});

  final int idRessource;

  @override
  State<DetailRessourcePage> createState() => _ListerRessourcesPageState();
}

class _ListerRessourcesPageState extends State<DetailRessourcePage> {
  late Future<Ressource> futureRessource;
  @override
  void initState() {
    super.initState();
    futureRessource = fetchRessources(widget.idRessource);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ressource'),
        backgroundColor: const Color(0xFFFFBD59),
      ),
      body: FutureBuilder<Ressource>(
          future: futureRessource,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.network('http://82.66.110.4:8000/${snapshot.data!.fileUrl!}'),
                  Text(
                    snapshot.data!.titre,
                    style: DefaultTextStyle.of(context)
                        .style
                        .apply(fontSizeFactor: 2.0),
                    textAlign: TextAlign.start,
                  ),
                  const Divider(),
                  Text('Catégorie : ${snapshot.data!.ressourceCategorie.titre}'),
                  Text('Type de relations : ${snapshot.data!.relationType.titre}'),
                  Text(
                      'Type de ressource : ${snapshot.data!.ressourceType?.titre}'),
                  Text('${snapshot.data!.utilisateur.prenom} '
                      '${snapshot.data!.utilisateur.nom} - '
                      '${snapshot.data!.dateModification.day}/'
                      '${snapshot.data!.dateModification.month}/'
                      '${snapshot.data!.dateModification.year}'),
                  const Divider(),
                  Text(
                    snapshot.data!.description,
                  ),
                  const Divider(),
                  Text(snapshot.data!.contenu!),
                  Expanded(
                    flex: 1,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.commentaires!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(snapshot.data!.commentaires![index].contenu),
                        );
                      },
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AjoutCommentaire(ressourceId: snapshot.data!.id,)),
                      );
                    },
                    child: const Icon(Icons.comment),
                  )
                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
    );
  }
}
