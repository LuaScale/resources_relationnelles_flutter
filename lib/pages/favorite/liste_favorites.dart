import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:resources_relationnelles_flutter/classes/favorie.dart';
import 'package:resources_relationnelles_flutter/pages/ressources/detail_ressource.dart';
import 'package:resources_relationnelles_flutter/services/get_user.dart';
import 'package:resources_relationnelles_flutter/services/ressource_services.dart';
import 'package:resources_relationnelles_flutter/widgets/custom_appbar.dart';
import 'package:resources_relationnelles_flutter/services/secure_storage.dart';

Future<List<Favorie>> fetchFavories() async {
    String? cle = dotenv.env['API_KEY'];
    String? apiurl = dotenv.env['API_URL'];
    final SecureStorage storage = SecureStorage();
    String? token = await storage.readSecureData('token');
  final response = await http.get(
    Uri.parse('$apiurl/api/my-favorites'),
    headers: {
      'X-API-Key': '$cle',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    List jsonListeFavories = jsonResponse["hydra:member"];
    List<Favorie> listFavories = [];
    for(var v in jsonListeFavories){
      Favorie favorie = Favorie.fromJson(v as Map<String, dynamic>);
      print('test');
      listFavories.add(favorie);
    }
    return listFavories;
  } else {
    throw Exception('Failed to load favories');
  }
}

class ListerFavoriesPage extends StatefulWidget {
  const ListerFavoriesPage({super.key});

   @override
   State<ListerFavoriesPage> createState() => _ListerFavoriesPageState();
}

class _ListerFavoriesPageState extends State<ListerFavoriesPage> {
  late Future<List<Favorie>> futureFavories;

  @override
  void initState() {
    super.initState();
    futureFavories = fetchFavories();
  }

  void deleteFavorite(String favorieUrl) async{
    const snackBarSuccess = SnackBar(content: Text('Favori Supprimé !'));
    const snackBarGuest = SnackBar(content: Text('Vous devez vous connecter !'));
    const snackBarError = SnackBar(content: Text('Une erreur est survenue !'));

    final scaffoldMessenger = ScaffoldMessenger.of(context);

    var user = await fetchUtilisateurByToken();
    if(user == false){
       scaffoldMessenger.showSnackBar(snackBarGuest);
       return;
    }

    var result = await RessourceServices().deleteFavorite(favorieUrl);
    if(result == true){
      scaffoldMessenger.showSnackBar(snackBarSuccess);
    } else {
      scaffoldMessenger.showSnackBar(snackBarError);
    }
    setState(() {
          futureFavories = fetchFavories();
    });
  }
  
  @override
  Widget build(BuildContext context) {

    const favIcon = Icon(
                      Icons.restore_from_trash,
                      color: Colors.red,
                      size: 24.0,
                    );
    return Scaffold(
      appBar: const CustomAppBar(
          title: Text('Favoris'),
      ),
      body:
       Center(
        child: FutureBuilder<List<Favorie>>(
          future: futureFavories,
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return ListView.builder(

                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.all(12),
                    child: ListTile(
                    leading: Image.network('http://82.66.110.4:8000/${snapshot.data![index].ressource.fileUrl!}'),
                    title: Text(snapshot.data![index].ressource.titre),
                    enabled: true,
                    trailing:IconButton(icon: favIcon, onPressed: () {
                      deleteFavorite(snapshot.data![index].id);
                    }),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailRessourcePage(idRessource: snapshot.data![index].ressource.id),
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