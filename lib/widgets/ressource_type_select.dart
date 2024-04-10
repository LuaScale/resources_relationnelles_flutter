import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:resources_relationnelles_flutter/classes/ressource_type.dart';
import 'package:http/http.dart' as http;

Future<List<RessourceType>> fetchRessourceTypes() async {
  var token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpYXQiOjE3MTI3NTAzMTcsImV4cCI6MTcxMjc1MzkxNywicm9sZXMiOlsiUk9MRV9VU0VSIl0sInVzZXJuYW1lIjoidGVzdEBhcGkuY29tIn0.eCjtD5TqU1CpYNG7tsFga4_symuBfyUif3lVHP0UIJAGSo9Msb1iBhdB33NKcJc1nkoaBgTmjVeggnhUq80t2NrABh82MaTnFomvVnJDW7Og3j1p9zU6bpz7QiMMcwT644ll2fuiPLQx6oJKB-k6qnjOpiN80PViRp0rYZbEM2C1rfsajVwvmd9RZNb-gk1eg8Jl80UKJGOJea2MU3lPCTqPLE4oAEgsRVssAgUkPsZOtDE0KuY2h46fnIrtOrpfJl9dxo2ljQ7GfK_J7NPvLKsiL6HewhxO4ZaEzFu9c10lnoqm5ZZ6DnWIM2frrDtIKGDtZ7xhcSJfezOY0kYvag';
  final response = await http.get(
      Uri.parse('http://82.66.110.4:8000/api/ressource_types/'),
      headers: {
        'X-API-Key': 'test',
        'Authorization': 'Bearer $token'
      },
    );

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    List jsonListeRessourceType = jsonResponse["hydra:member"];
    return jsonListeRessourceType.map((item) => RessourceType.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load RessourceTypes');
  }
}


class RessourceTypeDropdown extends StatefulWidget {
  const RessourceTypeDropdown({super.key});

  @override
  State<RessourceTypeDropdown> createState() => _RessourceTypeDropdownState();
}

class _RessourceTypeDropdownState extends State<RessourceTypeDropdown> {
  late Future<List<RessourceType>> futureRessourceTypes;
  String? dropdownValue;

  @override
  void initState() {
    super.initState();
    futureRessourceTypes = fetchRessourceTypes();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RessourceType>>(
      future: futureRessourceTypes,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return DropdownButton<String>(
            value: dropdownValue,
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue;
              });
            },
            items: snapshot.data!.map<DropdownMenuItem<String>>((RessourceType value) {
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