import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:resources_relationnelles_flutter/classes/ressource_categorie.dart';
import 'package:http/http.dart' as http;

import '../services/secure_storage.dart';

Future<List<RessourceCategorie>> fetchRessourceCategories() async {
  String? cle = dotenv.env['API_KEY'];
  final SecureStorage storage = SecureStorage();
  String? token = await storage.readSecureData('token');
  final response = await http.get(
      Uri.parse('http://82.66.110.4:8000/api/ressource_categories/'),
      headers: {
        'X-API-Key': '$cle',
        'Authorization': 'Bearer $token'
      },
    );

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    List jsonListeRessourceCategories = jsonResponse["hydra:member"];
    return jsonListeRessourceCategories.map((item) => RessourceCategorie.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load ResourceCategories');
  }
}


class RessourceCategoriesDropdown extends StatefulWidget {
  final ValueChanged<RessourceCategorie?>? onValueChanged;
  const RessourceCategoriesDropdown({super.key, this.onValueChanged});

  @override
  State<RessourceCategoriesDropdown> createState() => _RessourceTypeDropdownState();
}

class _RessourceTypeDropdownState extends State<RessourceCategoriesDropdown> {
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
        if (snapshot.hasData) {
          return DropdownButton<RessourceCategorie>(
            value: dropdownValue,
            onChanged: (RessourceCategorie? newValue) {
              setState(() {
                dropdownValue = newValue;
              });
              widget.onValueChanged?.call(newValue);
            },
            items: snapshot.data!.map<DropdownMenuItem<RessourceCategorie>>((RessourceCategorie value) {
              return DropdownMenuItem<RessourceCategorie>(
                value: value,
                child: Text(value.titre),
              );
            }).toList(),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }
}