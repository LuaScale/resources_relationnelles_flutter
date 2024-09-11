import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:resources_relationnelles_flutter/services/secure_storage.dart';
import 'package:http/http.dart' as http;

class CommentaireServices {
  Future<bool> validerCommentaire(int idCommentaire) async {
    String? cle = dotenv.env['API_KEY'];
    String? apiurl = dotenv.env['API_URL'];
    final SecureStorage storage = SecureStorage();
    String? token = await storage.readSecureData('token');
    final response = await http.patch(
      Uri.parse('$apiurl/api/comments/accept/$idCommentaire'),
      headers: {
        'X-API-Key': '$cle',
        'Authorization': 'Bearer $token',
        HttpHeaders.contentTypeHeader : "application/merge-patch+json"
      },
      body: jsonEncode({})
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}