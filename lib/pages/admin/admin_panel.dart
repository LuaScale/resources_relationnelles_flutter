
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:resources_relationnelles_flutter/classes/stats.dart';
import 'package:resources_relationnelles_flutter/services/ressource_services.dart';
import 'package:resources_relationnelles_flutter/widgets/custom_button.dart';
import 'package:resources_relationnelles_flutter/widgets/custom_sidebar.dart';
import 'package:resources_relationnelles_flutter/widgets/text_input.dart';
import 'package:resources_relationnelles_flutter/widgets/custom_appbar.dart';

class AdminPanelPage extends StatefulWidget {
  const AdminPanelPage({super.key});

  @override
  _AdminPanelPageState createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> {

  final TextEditingController _relationController = TextEditingController();
  final TextEditingController _categorieController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();

  void _validateAndSubmitCategorie() async {
    String titre = _categorieController.text;
    var result = await RessourceServices().addCategorie(titre);
    if(result){
          ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Categorie de ressource ajoutée avec succès'),
      ),
    );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Un problème est survenue'),
      ),
      );
    }
  }
    void _validateAndSubmitType() async {
    String titre = _typeController.text;
    var result = await RessourceServices().addType(titre);
    if(result){
          ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('type de ressource ajoutée avec succès'),
      ),
    );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Un problème est survnue'),
      ),
      );
    }
  }
    void _validateAndSubmitRelation() async {
    String titre = _relationController.text;
    var result = await RessourceServices().addRelation(titre);
    if(result){
          ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Type de relation ajoutée avec succès'),
      ),
    );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Un problème est survnue'),
      ),
      );
    }
    
  }
  Future<Stats> fetchRessources() async {
  String? cle = dotenv.env['API_KEY'];
  String? apiurl = dotenv.env['API_URL'];
  final response = await http.get(
    Uri.parse('$apiurl/api/ressources/count/'),
    headers: {
      'X-API-Key': '$cle',
    },
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    return Stats.fromJson(jsonResponse);
  } else {
    throw Exception('Failed to load ressource');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: Text("Panneau d'administration"),
      ),
      drawer: const CustomSidebar(),
      backgroundColor: const Color(0xFF03989E),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomTextInput(controller: _relationController, labelText: 'Type de relation', maxLines: 1, maxLength: 50),
                  CustomButton(text: 'Ajouter', onPressed: _validateAndSubmitRelation),
                ],
              ),
              const SizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomTextInput(controller: _categorieController, labelText: 'Catégorie de ressource', maxLines: 2, maxLength: 200),
                  CustomButton(text: 'Ajouter', onPressed: _validateAndSubmitCategorie),
                ],
              ),
              const SizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomTextInput(controller: _typeController, labelText: 'Type de ressource', maxLines: 5, maxLength: 1000),
                  CustomButton(text: 'Ajouter', onPressed: _validateAndSubmitType),
                ],
              ),
              const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}