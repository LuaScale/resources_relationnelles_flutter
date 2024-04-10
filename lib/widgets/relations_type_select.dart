import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:resources_relationnelles_flutter/classes/relation_type.dart';
import 'package:http/http.dart' as http;

import '../services/secure_storage.dart';

Future<List<RelationType>> fetchRelationsType() async {
  String? cle = dotenv.env['API_KEY'];
  final SecureStorage storage = SecureStorage();
  String? token = await storage.readSecureData('token');
  final response = await http.get(
      Uri.parse('http://82.66.110.4:8000/api/relation_types/'),
      headers: {
        'X-API-Key': '$cle',
        'Authorization': 'Bearer $token'
      },
    );

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    List jsonListeRessourceCategories = jsonResponse["hydra:member"];
    return jsonListeRessourceCategories.map((item) => RelationType.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load ResourceCategories');
  }
}


class RelationTypesDropdown extends StatefulWidget {
  final ValueChanged<RelationType?>? onValueChanged;
  const RelationTypesDropdown({super.key, this.onValueChanged});

  @override
  State<RelationTypesDropdown> createState() => _RessourceTypeDropdownState();
}

class _RessourceTypeDropdownState extends State<RelationTypesDropdown> {
  late Future<List<RelationType>> futureRelationsType;
  RelationType? dropdownValue;

  @override
  void initState() {
    super.initState();
    futureRelationsType = fetchRelationsType();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RelationType>>(
      future: futureRelationsType,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return DropdownButton<RelationType>(
            value: dropdownValue,
            onChanged: (RelationType? newValue) {
              setState(() {
                dropdownValue = newValue;
              });
              widget.onValueChanged?.call(newValue);
            },
            items: snapshot.data!.map<DropdownMenuItem<RelationType>>((RelationType value) {
              return DropdownMenuItem<RelationType>(
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