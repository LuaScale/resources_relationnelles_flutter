import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resources_relationnelles_flutter/classes/relation_type.dart';
import 'package:resources_relationnelles_flutter/classes/ressource_categorie.dart';
import 'package:resources_relationnelles_flutter/services/ressource_services.dart';
import 'package:resources_relationnelles_flutter/widgets/custom_button.dart';
import 'package:resources_relationnelles_flutter/widgets/relations_type_select.dart';
import 'package:resources_relationnelles_flutter/widgets/text_input.dart';
import 'package:resources_relationnelles_flutter/widgets/text_area.dart';
import 'package:resources_relationnelles_flutter/widgets/custom_appbar.dart';
import '../../classes/ressource_type.dart';
import '../../widgets/ressource_categorie_select.dart';
import '../../widgets/ressource_type_select.dart';

class CreerRessourcePage extends StatefulWidget {
  const CreerRessourcePage({super.key});

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

  RessourceType? selectedRessourceType;
  RessourceCategorie? selectedRessourceCategorie;
  RelationType? selectedRelationType;

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
    RessourceType? ressourceType = selectedRessourceType;
    RessourceCategorie? ressourceCategorie = selectedRessourceCategorie;
    RelationType? relationType = selectedRelationType;
    String? file = _imageFile?.path;

    // Assurez-vous que tous les champs obligatoires sont renseignés
    if (titre.isEmpty || description.isEmpty || contenu.isEmpty || ressourceType == null || ressourceCategorie == null || relationType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tous les champs obligatoires doivent être renseignés.'),
        ),
      );
      return;
    }

    Map<String, dynamic> ressource = {
      'title': titre,
      'description': description,
      'content': contenu,
      'ressourceType': ressourceType.id,
      'ressourceCategory': ressourceCategorie.id,
      'relationType': relationType.id,
      'file': file,
    };

    RessourceServices().addRessource(ressource);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ressource ajoutée avec succès'),
      ),
    );
    _resetFields(); // Réinitialiser les champs après la soumission
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: Text('Créer'),
      ),
      backgroundColor: const Color(0xFF03989E),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;
              final isSmallScreen = screenWidth < 600; // Définir une largeur limite pour un petit écran

              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomTextInput(
                      controller: _titreController,
                      labelText: 'Titre',
                      maxLines: 1,
                      maxLength: 50,
                    ),
                    const SizedBox(height: 10),

                    // Disposition conditionnelle des dropdowns
                    if (isSmallScreen) // Si c'est un petit écran, les dropdowns sont empilés verticalement dans une Column
                      Column(
                        children: [
                          RessourceTypeDropdown(
                            onValueChanged: (newValue) {
                              setState(() {
                                selectedRessourceType = newValue;
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          RessourceCategoriesDropdown(
                            onValueChanged: (newValue) {
                              setState(() {
                                selectedRessourceCategorie = newValue;
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          RelationTypesDropdown(
                            onValueChanged: (newValue) {
                              setState(() {
                                selectedRelationType = newValue;
                              });
                            },
                          ),
                        ],
                      )
                    else
                      // Si c'est un grand écran, les dropdowns sont disposés côte à côte dans une Row
                      SizedBox(
                        width: screenWidth * 0.6, // Réduisez la largeur de la Row à 60% de la largeur de l'écran
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: RessourceTypeDropdown(
                                onValueChanged: (newValue) {
                                  setState(() {
                                    selectedRessourceType = newValue;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: RessourceCategoriesDropdown(
                                onValueChanged: (newValue) {
                                  setState(() {
                                    selectedRessourceCategorie = newValue;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: RelationTypesDropdown(
                                onValueChanged: (newValue) {
                                  setState(() {
                                    selectedRelationType = newValue;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 10),
                    CustomTextInput(
                      controller: _descriptionController,
                      labelText: 'Description',
                      maxLines: 2,
                      maxLength: 200,
                    ),
                    const SizedBox(height: 10),
                    CustomTextArea(
                      controller: _contenuController,
                      labelText: 'Contenu',
                      maxLines: 5,
                      maxLength: 1000,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.add_photo_alternate,
                            size: 48,
                            color: Color(0xFFFFBD59),
                          ),
                          onPressed: _pickImage,
                          tooltip: 'Ajouter une image',
                        ),
                        const SizedBox(width: 40),
                        IconButton(
                          icon: const Icon(
                            Icons.video_library,
                            size: 48,
                            color: Color(0xFFFFBD59),
                          ),
                          onPressed: _pickVideo,
                          tooltip: 'Ajouter une vidéo',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomButton(
                          text: 'Annuler',
                          onPressed: _resetFields,
                        ),
                        CustomButton(
                          text: 'Valider',
                          onPressed: _validateAndSubmit,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
