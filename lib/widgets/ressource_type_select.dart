import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:resources_relationnelles_flutter/classes/ressource.dart';
import 'package:resources_relationnelles_flutter/classes/ressource_type.dart';
import 'package:http/http.dart' as http;

import '../services/secure_storage.dart';

Future<List<RessourceType>> fetchRessourceTypes() async {
  String? cle = dotenv.env['API_KEY'];
  final SecureStorage storage = SecureStorage();
  String? token = await storage.readSecureData('token');
  final response = await http.get(
      Uri.parse('http://82.66.110.4:8000/api/ressource_types/'),
      headers: {
        'X-API-Key': '$cle',
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
  final ValueChanged<RessourceType?>? onValueChanged;
  const RessourceTypeDropdown({super.key, this.onValueChanged});
  @override
  State<RessourceTypeDropdown> createState() => _RessourceTypeDropdownState();
}

class _RessourceTypeDropdownState extends State<RessourceTypeDropdown> {
  late Future<List<RessourceType>> futureRessourceTypes;
  RessourceType? dropdownValue;

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
          return DropdownButton<RessourceType>(
            value: dropdownValue,
            onChanged: (RessourceType? newValue) {
              setState(() {
                dropdownValue = newValue;
              });
              widget.onValueChanged?.call(newValue);
            },
            items: snapshot.data!.map<DropdownMenuItem<RessourceType>>((RessourceType value) {
              return DropdownMenuItem<RessourceType>(
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