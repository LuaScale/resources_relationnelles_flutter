import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../services/secure_storage.dart';

Future<bool> ajoutCommentaire(int idRessource, String commentaire) async {
  String? cle = dotenv.env['API_KEY'];
  final SecureStorage storage = SecureStorage();
  String? token = await storage.readSecureData('token');
  final response = await http.post(
    Uri.parse('http://82.66.110.4:8000/api/comments'),
    headers: {
      'X-API-Key': '$cle',
      'Authorization': 'Bearer $token',
      HttpHeaders.contentTypeHeader : "application/json"
    },
    body: jsonEncode(<String, dynamic>{
      'ressource': '/api/ressources/$idRessource',
      'content': commentaire,
    }),
  );
  if (response.statusCode == 201) {
    print('Commentaire ajouté avec succès');
    return true;
  } else {
    throw Exception('Échec de l\'ajout du commentaire');
  }
}

class AjoutCommentaire extends StatefulWidget {
  final int ressourceId;
  const AjoutCommentaire({super.key, required this.ressourceId});

  @override
  State<AjoutCommentaire> createState() => _AjoutCommentaireState();
}

class _AjoutCommentaireState extends State<AjoutCommentaire> {
  final _formKey = GlobalKey<FormState>();
  String _commentaire = '';
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un commentaire'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Votre commentaire',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un commentaire';
                  }
                  return null;
                },
                onSaved: (value) {
                  _commentaire = value!;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    ajoutCommentaire(widget.ressourceId, _commentaire);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Soumettre'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}