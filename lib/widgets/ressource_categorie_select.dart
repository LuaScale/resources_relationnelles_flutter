import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:resources_relationnelles_flutter/classes/ressource_categorie.dart';
import 'package:http/http.dart' as http;

Future<List<RessourceCategorie>> fetchRessourceCategories() async {
  var token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpYXQiOjE3MTI3NTAzMTcsImV4cCI6MTcxMjc1MzkxNywicm9sZXMiOlsiUk9MRV9VU0VSIl0sInVzZXJuYW1lIjoidGVzdEBhcGkuY29tIn0.eCjtD5TqU1CpYNG7tsFga4_symuBfyUif3lVHP0UIJAGSo9Msb1iBhdB33NKcJc1nkoaBgTmjVeggnhUq80t2NrABh82MaTnFomvVnJDW7Og3j1p9zU6bpz7QiMMcwT644ll2fuiPLQx6oJKB-k6qnjOpiN80PViRp0rYZbEM2C1rfsajVwvmd9RZNb-gk1eg8Jl80UKJGOJea2MU3lPCTqPLE4oAEgsRVssAgUkPsZOtDE0KuY2h46fnIrtOrpfJl9dxo2ljQ7GfK_J7NPvLKsiL6HewhxO4ZaEzFu9c10lnoqm5ZZ6DnWIM2frrDtIKGDtZ7xhcSJfezOY0kYvag';
  final response = await http.get(
      Uri.parse('http://82.66.110.4:8000/api/ressource_categories/'),
      headers: {
        'X-API-Key': 'test',
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
  const RessourceCategoriesDropdown({super.key});

  @override
  State<RessourceCategoriesDropdown> createState() => _RessourceTypeDropdownState();
}

class _RessourceTypeDropdownState extends State<RessourceCategoriesDropdown> {
  late Future<List<RessourceCategorie>> futureRessourceCategories;
  String? dropdownValue;

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
          return DropdownButton<String>(
            value: dropdownValue,
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue;
              });
            },
            items: snapshot.data!.map<DropdownMenuItem<String>>((RessourceCategorie value) {
              return DropdownMenuItem<String>(
                value: value.titre,
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