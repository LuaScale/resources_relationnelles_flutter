import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:resources_relationnelles_flutter/classes/relation_type.dart';
import '../services/secure_storage.dart';

Future<List<RelationType>> fetchRelationsType() async {
  final String? apiKey = dotenv.env['API_KEY'];
  final SecureStorage storage = SecureStorage();
  final String? token = await storage.readSecureData('token');
  final response = await http.get(
    Uri.parse('http://82.66.110.4:8000/api/relation_types/'),
    headers: {
      'X-API-Key': apiKey ?? '',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    final List jsonListeRelationsType = jsonResponse['hydra:member'];
    return jsonListeRelationsType.map((item) => RelationType.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load relation types');
  }
}

class RelationTypesDropdown extends StatefulWidget {
  final ValueChanged<RelationType?>? onValueChanged;

  const RelationTypesDropdown({super.key, this.onValueChanged});

  @override
  _RelationTypesDropdownState createState() => _RelationTypesDropdownState();
}

class _RelationTypesDropdownState extends State<RelationTypesDropdown> {
  late Future<List<RelationType>> futureRelationsType;
  RelationType? dropdownValue;

  @override
  void initState() {
    super.initState();
    futureRelationsType = fetchRelationsType();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // FutureBuilder pour charger les données de manière asynchrone
        FutureBuilder<List<RelationType>>(
          future: futureRelationsType,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Erreur : ${snapshot.error}');
            } else if (snapshot.hasData) {
              final List<RelationType> relationTypes = snapshot.data!;
              return Container(
                width: MediaQuery.of(context).size.width * 0.60,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200, // Couleur de fond grise claire
                  borderRadius: BorderRadius.circular(8), // Bordures arrondies
                ),
                child: DropdownButton<RelationType>(
                  value: dropdownValue,
                  onChanged: (RelationType? newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                    widget.onValueChanged?.call(newValue);
                  },
                  items: relationTypes.map<DropdownMenuItem<RelationType>>((RelationType value) {
                    return DropdownMenuItem<RelationType>(
                      value: value,
                      child: Text(value.titre),
                    );
                  }).toList(),
                  dropdownColor: Colors.grey.shade200, // Couleur de fond du menu déroulant
                  isExpanded: true, // Permet au dropdown de s'étendre sur toute la largeur disponible
                  hint: Text(
                    'Type de relation', // Label ou placeholder
                    style: TextStyle(color: Colors.grey.shade600), // Couleur de texte du hint
                  ),
                ),
              );
            }
            return const Text('Aucune donnée');
          },
        ),
      ],
    );
  }
}
