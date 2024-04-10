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

import '../../classes/ressource_type.dart';
import '../../widgets/ressource_categorie_select.dart';
import '../../widgets/ressource_type_select.dart';

class CreerRessourcePage extends StatefulWidget {
  const CreerRessourcePage({Key? key}) : super(key: key);

  @override
  _CreerRessourcePageState createState() => _CreerRessourcePageState();
}

class _CreerRessourcePageState extends State<CreerRessourcePage> {
  final TextEditingController _titreController = TextEditingController();
  final TextEditingController _categorieController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _contenuController = TextEditingController();
  File? _imageFile;
  File? _videoFile;

  // Méthode pour sélectionner une image depuis la galerie
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  // Méthode pour sélectionner une vidéo depuis la galerie
  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final pickedVideo = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedVideo != null) {
      setState(() {
        _videoFile = File(pickedVideo.path);
      });
    }
  }

  // Méthode pour réinitialiser les champs et les fichiers sélectionnés
  void _resetFields() {
    _titreController.clear();
    _categorieController.clear();
    _descriptionController.clear();
    _contenuController.clear();
    setState(() {
      _imageFile = null;
      _videoFile = null;
    });
  }

  // Méthode pour valider et soumettre les données
  void _validateAndSubmit() {
    String titre = _titreController.text;
    String description = _descriptionController.text;
    String contenu = _contenuController.text;
    RessourceType ressourceType = selectedRessourceType as RessourceType;
    RessourceCategorie ressourceCategorie = selectedRessourceCategorie as RessourceCategorie;
    RelationType relationType = selectedRelationType as RelationType;
    Map<String, dynamic> ressource = {
      'title' : titre,
      'description' : description,
      'content' : contenu,
      'ressourceType' : ressourceType.id,
      'ressourceCategory' : ressourceCategorie.id,
      'relationType' : relationType.id,
    };
    RessourceServices().addRessource(ressource);
  }
  RessourceType? selectedRessourceType;
  RessourceCategorie? selectedRessourceCategorie;
  RelationType? selectedRelationType;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer une ressource'),
        backgroundColor: const Color(0xFFFFBD59),
      ),
      backgroundColor: const Color(0xFF03989E),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Champ de texte pour le titre
                CustomTextInput(controller: _titreController, labelText: 'Titre', maxLines: 1, maxLength: 50),
                const SizedBox(height: 10),
                // Champ de texte pour la catégorie
                RessourceTypeDropdown(
                  onValueChanged: (newValue) {
                    setState(() {
                      selectedRessourceType = newValue;
                    });
                  },
                ),
                RessourceCategoriesDropdown(
                  onValueChanged: (newValue) {
                    setState(() {
                      selectedRessourceCategorie = newValue;
                    });
                  },
                ),
                RelationTypesDropdown(
                  onValueChanged: (newValue) {
                    setState(() {
                      selectedRelationType = newValue;
                    });
                  },
                ),
                const SizedBox(height: 10),
                // Champ de texte pour la description
                CustomTextInput(controller: _descriptionController, labelText: 'Description', maxLines: 2, maxLength: 200),
                const SizedBox(height: 10),
                // Champ de texte multiligne pour le contenu
                CustomTextArea(controller: _contenuController, labelText: 'Contenu', maxLines: 5, maxLength: 1000),
                const SizedBox(height: 20),
                // Boutons d'ajout de photo et de vidéo
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add_photo_alternate, size: 48, color: Color(0xFFFFBD59)),
                      onPressed: _pickImage,
                      tooltip: 'Ajouter une image',
                    ),
                    const SizedBox(width: 40), // Espacement entre les icônes
                    // Bouton pour ajouter une vidéo depuis la galerie
                    IconButton(
                      icon: const Icon(Icons.video_library, size: 48, color: Color(0xFFFFBD59)),
                      onPressed: _pickVideo,
                      tooltip: 'Ajouter une vidéo',
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Boutons d'annulation et de validation
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Bouton "Annuler"
                    CustomButton(text: 'Annuler', onPressed: _resetFields),
                    // Bouton "Valider"
                    CustomButton(text: 'Valider', onPressed: _validateAndSubmit),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
