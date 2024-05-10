import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:resources_relationnelles_flutter/classes/ressource_categorie.dart';
import '../services/secure_storage.dart';

Future<List<RessourceCategorie>> fetchRessourceCategories() async {
  final String? apiKey = dotenv.env['API_KEY'];
  final SecureStorage storage = SecureStorage();
  final String? token = await storage.readSecureData('token');
  final response = await http.get(
    Uri.parse('http://82.66.110.4:8000/api/ressource_categories/'),
    headers: {
      'X-API-Key': apiKey ?? '',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    final List jsonListeRessourceCategories = jsonResponse['hydra:member'];
    return jsonListeRessourceCategories.map((item) => RessourceCategorie.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load resource categories');
  }
}

class RessourceCategoriesDropdown extends StatefulWidget {
  final ValueChanged<RessourceCategorie?>? onValueChanged;

  const RessourceCategoriesDropdown({Key? key, this.onValueChanged}) : super(key: key);

  @override
  _RessourceCategoriesDropdownState createState() => _RessourceCategoriesDropdownState();
}

class _RessourceCategoriesDropdownState extends State<RessourceCategoriesDropdown> {
  late Future<List<RessourceCategorie>> futureRessourceCategories;
  RessourceCategorie? dropdownValue;

  @override
  void initState() {
    super.initState();
    futureRessourceCategories = fetchRessourceCategories();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RessourceCategorie>>(
      future: futureRessourceCategories,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Erreur : ${snapshot.error}');
        } else if (snapshot.hasData) {
          final List<RessourceCategorie> ressourceCategories = snapshot.data!;
          return Container(
            width: MediaQuery.of(context).size.width * 0.60,
            decoration: BoxDecoration(
              color: Colors.grey[200], // Couleur de fond grise claire
              borderRadius: BorderRadius.circular(8), // Bordures arrondies
            ),
            child: DropdownButton<RessourceCategorie>(
              value: dropdownValue,
              onChanged: (RessourceCategorie? newValue) {
                setState(() {
                  dropdownValue = newValue;
                });
                widget.onValueChanged?.call(newValue);
              },
              items: ressourceCategories.map<DropdownMenuItem<RessourceCategorie>>((RessourceCategorie value) {
                return DropdownMenuItem<RessourceCategorie>(
                  value: value,
                  child: Text(value.titre),
                );
              }).toList(),
              dropdownColor: Colors.grey.shade200, // Couleur de fond du menu déroulant
              isExpanded: true, // Permet au dropdown de s'étendre sur toute la largeur disponible
              hint: Text(
                'catégorie de ressource', // Label ou placeholder
                style: TextStyle(color: Colors.grey.shade600), // Couleur de texte du placeholder
              ),
            ),
          );
        }
        return const Text('Aucune donnée');
      },
    );
  }
}
