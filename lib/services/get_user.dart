import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:resources_relationnelles_flutter/classes/utilisateur.dart';
import 'package:resources_relationnelles_flutter/services/secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<dynamic> fetchUtilisateurByToken() async {
    String? cle = dotenv.env['API_KEY'];
    String? apiurl = dotenv.env['API_URL'];
    final SecureStorage storage = SecureStorage();
    String? token = await storage.readSecureData('token');
  final response = await http.get(
      Uri.parse('$apiurl/api/users/current'),
      headers: {
      'X-API-Key': '$cle',
      'Authorization': 'Bearer $token'
      },
  );
  if (response.statusCode == 200) {
    return Utilisateur.fromJson(json.decode(response.body));
  }else{
    if(response.statusCode == 401){
      return false;
    } else {
    throw Exception('Failed to load Utilisateur');
  }
  }
}