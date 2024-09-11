import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:resources_relationnelles_flutter/services/secure_storage.dart';

import 'package:http/http.dart' as http;

class RessourceServices {
  Future<bool> addRessource(Map<String, dynamic> ressource) async {
    String? cle = dotenv.env['API_KEY'];
      String? apiurl = dotenv.env['API_URL'];
    final SecureStorage storage = SecureStorage();
    String? token = await storage.readSecureData('token');
    final response = http.MultipartRequest('POST',
      Uri.parse('$apiurl/api/ressources'));
    var headers =  {
        'X-API-Key': '$cle',
        'Authorization': 'Bearer $token',
      };
    response.headers.addAll(headers);
    var file = ressource['file'];
    ressource.remove('file');
    ressource.forEach((key, value) {
      response.fields[key] = value;
    });
    if(file != null) {
      response.files.add(await http.MultipartFile.fromPath("file", file));
    }
    var rep = await response.send();
    if (rep.statusCode == 201) {
      return true;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to add ressource');
    }
  }

  Future<String> addFavorite(int idRessource) async {
    String? cle = dotenv.env['API_KEY'];
    String? apiurl = dotenv.env['API_URL'];
    final SecureStorage storage = SecureStorage();
    String? token = await storage.readSecureData('token');
  final response = await http.post(
    Uri.parse('$apiurl/api/favorites'),
    headers: {
      'X-API-Key': '$cle',
      'Authorization': 'Bearer $token',
      HttpHeaders.contentTypeHeader : "application/json"
    },
    body: jsonEncode(<String, dynamic>{
      'ressource': '/api/ressources/$idRessource',
    }),
  );
  switch(response.statusCode){
    case 201:
      return 'Ressource ajouté avec succès';
    case 312: 
      return 'La ressource est dèjà en favorie';
    default:
      return 'Un problème est survenue';
  }
  }

  Future<bool> addCategorie(String categorie) async {
    String? cle = dotenv.env['API_KEY'];
    String? apiurl = dotenv.env['API_URL'];
    final SecureStorage storage = SecureStorage();
    String? token = await storage.readSecureData('token');
    final response = await http.post(
      Uri.parse('$apiurl/api/ressource_categories'),
      headers: {
        'X-API-Key': '$cle',
        'Authorization': 'Bearer $token',
        HttpHeaders.contentTypeHeader : "application/json"
      },
      body: jsonEncode(<String, dynamic>{
        'title': categorie,
      }),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
  Future<bool> addRelation(String relation) async {
    String? cle = dotenv.env['API_KEY'];
    String? apiurl = dotenv.env['API_URL'];
    final SecureStorage storage = SecureStorage();
    String? token = await storage.readSecureData('token');
    final response = await http.post(
      Uri.parse('$apiurl/api/relation_types'),
      headers: {
        'X-API-Key': '$cle',
        'Authorization': 'Bearer $token',
        HttpHeaders.contentTypeHeader : "application/json"
      },
      body: jsonEncode(<String, dynamic>{
        'title': relation,
      }),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
  Future<bool> addType(String types) async {
    String? cle = dotenv.env['API_KEY'];
    String? apiurl = dotenv.env['API_URL'];
    final SecureStorage storage = SecureStorage();
    String? token = await storage.readSecureData('token');
    final response = await http.post(
      Uri.parse('$apiurl/api/ressource_types'),
      headers: {
        'X-API-Key': '$cle',
        'Authorization': 'Bearer $token',
        HttpHeaders.contentTypeHeader : "application/json"
      },
      body: jsonEncode(<String, dynamic>{
        'title': types,
      }),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteFavorite(String favorieUrl) async {
    String? cle = dotenv.env['API_KEY'];
      String? apiurl = dotenv.env['API_URL'];
    final SecureStorage storage = SecureStorage();
    String? token = await storage.readSecureData('token');
    final response = await http.delete(
      Uri.parse("$apiurl$favorieUrl"),
      headers: {
        'X-API-Key': '$cle',
        'Authorization': 'Bearer $token',
        HttpHeaders.contentTypeHeader : "application/json"
      },
    );
    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }
  
  Future<bool> validerRessource(int idRessource) async {
    String? cle = dotenv.env['API_KEY'];
    String? apiurl = dotenv.env['API_URL'];
    final SecureStorage storage = SecureStorage();
    String? token = await storage.readSecureData('token');
    final response = await http.post(
      Uri.parse('$apiurl/api/ressources/accept/$idRessource'),
      headers: {
        'X-API-Key': '$cle',
        'Authorization': 'Bearer $token',
        HttpHeaders.contentTypeHeader : "application/json"
      },
      body: jsonEncode({}),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}