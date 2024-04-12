import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resources_relationnelles_flutter/classes/relation_type.dart';
import 'package:resources_relationnelles_flutter/classes/ressource.dart';
import 'package:resources_relationnelles_flutter/classes/ressource_categorie.dart';
import 'package:resources_relationnelles_flutter/classes/utilisateur.dart';
import 'package:resources_relationnelles_flutter/services/ressource_services.dart';
import 'package:resources_relationnelles_flutter/widgets/custom_button.dart';
import 'package:resources_relationnelles_flutter/widgets/relations_type_select.dart';
import 'package:resources_relationnelles_flutter/widgets/text_input.dart';
import 'package:resources_relationnelles_flutter/widgets/text_area.dart';
import 'package:resources_relationnelles_flutter/widgets/custom_appbar.dart';

import '../../classes/ressource_type.dart';


import '../../widgets/ressource_categorie_select.dart';
import '../../widgets/ressource_type_select.dart';

class AdminPanelPage extends StatefulWidget {
  const AdminPanelPage({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
          title: Text("Panneau d'administration"),
      ),
      backgroundColor: const Color(0xFF03989E),
      body: Center(
        child: Padding(
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
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomTextInput(controller: _categorieController, labelText: 'Catégorie de ressource', maxLines: 2, maxLength: 200),
                    CustomButton(text: 'Ajouter', onPressed: _validateAndSubmitCategorie),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomTextInput(controller: _typeController, labelText: 'Type de ressource', maxLines: 5, maxLength: 1000),
                    CustomButton(text: 'Ajouter', onPressed: _validateAndSubmitType),
                  ],
                ),
                const SizedBox(height: 20),
                // Boutons d'annulation et de validation,
              ],
            ),
          ),
        ),
      ),
    );
  }
}