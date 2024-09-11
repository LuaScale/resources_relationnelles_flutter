import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:resources_relationnelles_flutter/pages/ressources/liste_ressources.dart';
import 'package:resources_relationnelles_flutter/services/get_user.dart';
import 'package:resources_relationnelles_flutter/widgets/custom_appbar.dart';
import 'package:resources_relationnelles_flutter/widgets/custom_sidebar.dart';
import 'dart:html' as html;

void main() {
  runApp(const ResourcesRelationellesApp());
}

dynamic getUser() async {
    return await fetchUtilisateurByToken();
  }

class ResourcesRelationellesApp extends StatelessWidget {
  const ResourcesRelationellesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resources Relationelles',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      drawer: CustomSidebar(),
      appBar: CustomAppBar(
        title: Text('Resources Relationelles'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeroSection(),
            FeaturesSection(),
          ],
        ),
      ),
      bottomNavigationBar: Footer(),
    );
  }
}

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Ensures the container takes up the full width
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF123456), // Custom color using hex code
      ),
      child: Column(
        children: [
          const Text(
            'Bienvenue sur (RE)sources Relationelles',
            style: TextStyle(
              fontSize: 32,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const Text(
            'Restez connecté avec vos pairs et accédez à des ressources de qualité.',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ListerRessourcesPage()),
                          );},
            child: const Text('Démarrez maintenant'),
          ),
        ],
      ),
    );
  }
}

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: const Center(
        child: Column(
          children: [
            Text(
              'Nos fonctionnalités :',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            FeatureItem(
              icon: Icons.chat_bubble_outline,
              title: 'Interactions sur les posts',
              description:
                  'Entretenez des conversations riches avec nos membres.',
            ),
            FeatureItem(
              icon: Icons.library_books_outlined,
              title: 'Ressources nombreuses',
              description:
                  'Accédez à une vaste quantité de ressources mise à jour.',
            ),
            FeatureItem(
              icon: Icons.people_outline,
              title: 'Modération active',
              description:
                  'Profitez d\'une modération active pour une expérience sécurisée.',
            ),
            FeatureItem(
              icon: Icons.archive_outlined,
              title: 'Archives fournies',
              description:
                  'Consultez des archives riches et variées pour vos recherches.',
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const FeatureItem(
      {super.key,
      required this.icon,
      required this.title,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 40, color: Colors.blue),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 60),
      color: const Color(0xFF45B39D),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Ensure the column takes minimum space needed
        children: [
          const Text(
            'Resources Relationelles',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          const SizedBox(height: 10),
          const Text(
            'Restons en contact : contact@resourcesrelationelles.com',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.facebook),
                color: const Color.fromARGB(255, 0, 49, 112),
                onPressed: () {html.window.open("https://www.facebook.com/gouvernement.fr/?locale=fr_FR","new tab");},
              ),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.twitter),
                color: const Color.fromARGB(255, 40, 194, 255),
                onPressed: () {html.window.open("https://x.com/gouvernementfr?lang=en","new tab");},
              ),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.linkedin),
                color: const Color.fromARGB(255, 0, 132, 219),
                onPressed: () {html.window.open("https://www.linkedin.com/company/gouvernementfr/","new tab");},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
