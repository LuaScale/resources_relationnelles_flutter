import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:resources_relationnelles_flutter/classes/ressource.dart';
import 'package:resources_relationnelles_flutter/pages/ressources/detail_ressource.dart';
import 'package:resources_relationnelles_flutter/services/get_user.dart';
import 'package:resources_relationnelles_flutter/services/ressource_services.dart';
import 'package:resources_relationnelles_flutter/widgets/custom_appbar.dart';


Future<List<Ressource>> fetchRessources() async {
  String? cle = dotenv.env['API_KEY'];
  String? apiurl = dotenv.env['API_URL'];
  final response = await http.get(
    Uri.parse('$apiurl/api/ressources?page=&itemsPerPage=&pagination=&visible=&accepted=false&title='),
    headers: {
      'X-API-Key': '$cle',
    },
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    List jsonListeRessources = jsonResponse["hydra:member"];
    List<Ressource> listRessources = [];
    for(var v in jsonListeRessources){
      Ressource ressource = Ressource.fromJson(v as Map<String, dynamic>);
      listRessources.add(ressource);
    }
    return listRessources;
  } else {
    throw Exception('Failed to load ressource');
  }
}

class ListerRessourcesRestreintesPage extends StatefulWidget {
  const ListerRessourcesRestreintesPage({super.key});

  @override
  State<ListerRessourcesRestreintesPage> createState() => _ListerRessourcesRestreintesPageState();
}

class _ListerRessourcesRestreintesPageState extends State<ListerRessourcesRestreintesPage> {
  late Future<List<Ressource>> futureRessource;

  @override
  void initState() {
    super.initState();
    futureRessource = fetchRessources();
  }

  void validerRessource(int idRessource) async{
    const snackBarSuccess = SnackBar(content: Text('Ressource validée avec succès !'));
    const snackBarGuest = SnackBar(content: Text('Vous devez vous connecter !'));
    const snackBarError = SnackBar(content: Text('Une erreur est survenue !'));

    final scaffoldMessenger = ScaffoldMessenger.of(context);

    var user = await fetchUtilisateurByToken();
    if(user == false){
      scaffoldMessenger.showSnackBar(snackBarGuest);
      return;
    }

    var result = await RessourceServices().validerRessource(idRessource);
    if(result == true){
      scaffoldMessenger.showSnackBar(snackBarSuccess);
    } else {
      scaffoldMessenger.showSnackBar(snackBarError);
    }

    setState(() {
      futureRessource = fetchRessources();
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
      appBar: const CustomAppBar(
        title: Text('Moderation des Ressource'),
      ),
      body:
      Center(
        child: FutureBuilder<List<Ressource>>(
          future: futureRessource,
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return ListView.builder(

                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.all(20),
                    child: ListTile(
                      leading: Image.network('http://82.66.110.4:8000/${snapshot.data![index].fileUrl!}'),
                      title: Text(snapshot.data![index].titre),
                      subtitle: Text(snapshot.data![index].description),
                      enabled: true,
                      trailing:IconButton(icon: favIcon, onPressed: () {
                        validerRessource(snapshot.data![index].id);
                      }),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailRessourcePage(idRessource: snapshot.data![index].id),
                          ),
                        );
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