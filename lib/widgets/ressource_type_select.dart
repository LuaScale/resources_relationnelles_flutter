import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:resources_relationnelles_flutter/classes/ressource_type.dart';
import '../services/secure_storage.dart';

Future<List<RessourceType>> fetchRessourceTypes() async {
  final String? apiKey = dotenv.env['API_KEY'];
  final SecureStorage storage = SecureStorage();
  final String? token = await storage.readSecureData('token');
  final response = await http.get(
    Uri.parse('http://82.66.110.4:8000/api/ressource_types/'),
    headers: {
      'X-API-Key': apiKey ?? '',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    final List jsonListeRessourceTypes = jsonResponse['hydra:member'];
    return jsonListeRessourceTypes.map((item) => RessourceType.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load resource types');
  }
}

class RessourceTypeDropdown extends StatefulWidget {
  final ValueChanged<RessourceType?>? onValueChanged;

  const RessourceTypeDropdown({super.key, this.onValueChanged});

  @override
  _RessourceTypeDropdownState createState() => _RessourceTypeDropdownState();
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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Erreur : ${snapshot.error}');
        } else if (snapshot.hasData) {
          final List<RessourceType> ressourceTypes = snapshot.data!;
          return Container(
            width: MediaQuery.of(context).size.width * 0.60,
            decoration: BoxDecoration(
              color: Colors.grey.shade200, // Couleur de fond grise claire
              borderRadius: BorderRadius.circular(8), // Bordures arrondies
            ),
            child: DropdownButton<RessourceType>(
              value: dropdownValue,
              onChanged: (RessourceType? newValue) {
                setState(() {
                  dropdownValue = newValue;
                });
                widget.onValueChanged?.call(newValue);
              },
              items: ressourceTypes.map<DropdownMenuItem<RessourceType>>((RessourceType value) {
                return DropdownMenuItem<RessourceType>(
                  value: value,
                  child: Text(value.titre),
                );
              }).toList(),
              dropdownColor: Colors.grey.shade200, // Couleur de fond du menu déroulant
              isExpanded: true, // Permet au dropdown de s'étendre sur toute la largeur disponible
              hint: Text(
                'Type de ressource', // Label ou placeholder
                style: TextStyle(color: Colors.grey.shade600), // Couleur de texte du hint
              ),
            ),
          );
        }
        return const Text('Aucune donnée');
      },
    );
  }
}
