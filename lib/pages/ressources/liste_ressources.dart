import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:resources_relationnelles_flutter/classes/ressource.dart';
import 'package:resources_relationnelles_flutter/pages/ressources/detail_ressource.dart';
import 'package:resources_relationnelles_flutter/services/ressource_services.dart';

Future<List<Ressource>> fetchRessources() async {
  String? cle = dotenv.env['API_KEY'];
  String? apiurl = dotenv.env['API_URL'];
  final response = await http.get(
    Uri.parse('$apiurl/api/ressources?page=&itemsPerPage=&pagination=&visible=true&accepted=true&title='),
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

Future<List<Ressource>> addTofavorite() async {
  String? cle = dotenv.env['API_KEY'];
  String? apiurl = dotenv.env['API_URL'];
  final response = await http.get(
    Uri.parse('$apiurl/api/favorites'),
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

class ListerRessourcesPage extends StatefulWidget {
  const ListerRessourcesPage({super.key});

   @override
   State<ListerRessourcesPage> createState() => _ListerRessourcesPageState();
}

class _ListerRessourcesPageState extends State<ListerRessourcesPage> {
  late Future<List<Ressource>> futureRessource;

  @override
  void initState() {
    super.initState();
    futureRessource = fetchRessources();
  }

  void addFavorite(int idRessource) async{
    const snackBarSuccess = SnackBar(content: Text('Ressource Ajouté au favoris !'));
    const snackBarError = SnackBar(content: Text('Une erreur est survenue !'));

    final scaffoldMessenger = ScaffoldMessenger.of(context);

    var result = await RessourceServices().addFavorite(idRessource);
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
                      Icons.favorite,
                      color: Colors.black,
                      size: 24.0,
                      semanticLabel: 'Text to announce in accessibility modes',
                    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ressources'),
        backgroundColor: const Color(0xFFFFBD59),
      ),
      body: Center(
        child: FutureBuilder<List<Ressource>>(
          future: futureRessource,
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(snapshot.data![index].titre),
                    subtitle: Text(snapshot.data![index].description),
                    enabled: true,
                    trailing:IconButton(icon: favIcon, onPressed: () {
                      addFavorite(snapshot.data![index].id);
                    }),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailRessourcePage(idRessource: snapshot.data![index].id),
                          ),
                      );
                    },
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