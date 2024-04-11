import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:resources_relationnelles_flutter/services/secure_storage.dart';

import '../classes/ressource.dart';
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

  Future<bool> addFavorite(int idRessource) async {
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