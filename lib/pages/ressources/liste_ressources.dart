import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:resources_relationnelles_flutter/classes/ressource.dart';
import 'package:resources_relationnelles_flutter/pages/ressources/detail_ressource.dart';

Future<List<Ressource>> fetchRessources() async {
  final response = await http.get(
    Uri.parse('http://82.66.110.4:8000/api/ressources?page=&itemsPerPage=&pagination=&visible=&accepted=&title='),
    headers: {
      'X-API-Key': 'test',
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
  
  @override
  Widget build(BuildContext context) {
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