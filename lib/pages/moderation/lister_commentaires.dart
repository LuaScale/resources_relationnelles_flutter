import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:resources_relationnelles_flutter/classes/ressource.dart';
import 'package:resources_relationnelles_flutter/pages/ressources/detail_ressource.dart';
import 'package:resources_relationnelles_flutter/services/commentaire_services.dart';
import 'package:resources_relationnelles_flutter/services/get_user.dart';
import 'package:resources_relationnelles_flutter/services/ressource_services.dart';

import '../../classes/commentaire.dart';
import '../../services/secure_storage.dart';

Future<List<Commentaire>> fetchCommentaires() async {
  String? cle = dotenv.env['API_KEY'];
  String? apiurl = dotenv.env['API_URL'];
  final SecureStorage storage = SecureStorage();
  String? token = await storage.readSecureData('token');
  final response = await http.get(
    Uri.parse('$apiurl/api/comments?accepted=false'),
    headers: {
      'X-API-Key': '$cle',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    List jsonListCommentaires = jsonResponse["hydra:member"];
    List<Commentaire> listCommentaires = [];
    for(var v in jsonListCommentaires){
      Commentaire commentaire = Commentaire.fromJson(v as Map<String, dynamic>);
      listCommentaires.add(commentaire);
    }
    return listCommentaires;
  } else {
    throw Exception('Erreur lors du chargement des commentaires');
  }
}

class ListerCommentairesPage extends StatefulWidget {
  const ListerCommentairesPage({super.key});

  @override
  State<ListerCommentairesPage> createState() => _ListerCommentairesPageState();
}

class _ListerCommentairesPageState extends State<ListerCommentairesPage> {
  late Future<List<Commentaire>> futureCommentaires;

  @override
  void initState() {
    super.initState();
    futureCommentaires = fetchCommentaires();
  }

  void validerCommentaire(int idCommentaire) async{
    const snackBarSuccess = SnackBar(content: Text('Commentaire validé avec succès !'));
    const snackBarGuest = SnackBar(content: Text('Vous devez vous connecter !'));
    const snackBarError = SnackBar(content: Text('Une erreur est survenue !'));

    final scaffoldMessenger = ScaffoldMessenger.of(context);

    var user = await fetchUtilisateurByToken();
    if(user == false){
      scaffoldMessenger.showSnackBar(snackBarGuest);
      return;
    }

    var result = await CommentaireServices().validerCommentaire(idCommentaire);
    if(result == true){
      scaffoldMessenger.showSnackBar(snackBarSuccess);
    } else {
      scaffoldMessenger.showSnackBar(snackBarError);
    }

    setState(() {
      futureCommentaires = fetchCommentaires();
    });
  }

  @override
  Widget build(BuildContext context) {

    const favIcon = Icon(
      Icons.check,
      color: Colors.blueGrey,
      size: 24.0,
      semanticLabel: 'Text to announce in accessibility modes',
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modérer les commentaires'),
        backgroundColor: const Color(0xFFFFBD59),
      ),
      body:
      Center(
        child: FutureBuilder<List<Commentaire>>(
          future: futureCommentaires,
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return ListView.builder(

                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.all(20),
                    child: ListTile(
                      title: Text(snapshot.data![index].contenu),
                      enabled: true,
                      trailing:IconButton(icon: favIcon, onPressed: () {
                        validerCommentaire(snapshot.data![index].id);
                      }),
                      onTap: () {
                      },
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}