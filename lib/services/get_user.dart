import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:resources_relationnelles_flutter/classes/utilisateur.dart';
import 'package:resources_relationnelles_flutter/services/secure_storage.dart';

Future<dynamic> fetchUtilisateurByToken() async {
  final SecureStorage storage = SecureStorage();
  String? token = await storage.readSecureData('token');
  final response = await http.get(
      Uri.parse('http://82.66.110.4:8000/api/users/current'),
      headers: {
      'X-API-Key': 'test',
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