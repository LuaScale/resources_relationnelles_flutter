import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:resources_relationnelles_flutter/classes/utilisateur.dart';

Future<Utilisateur> fetchUtilisateurByToken(String token) async {
  final response = await http.get(
      Uri.parse('http://82.66.110.4:8000/api/users/current'),
      headers: {
      'X-API-Key': 'test',
      'Authorization': 'Bearer $token'
      },
  );
  if (response.statusCode == 200) {
    return Utilisateur.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load Utilisateur');
  }
}