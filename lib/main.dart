import 'package:flutter/material.dart';
import 'package:resources_relationnelles_flutter/pages/landing_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '(RE)SOURCES Relationnelles',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0x96008F77)),
        useMaterial3: true,
      ),
      home: const LandingPage(),
      debugShowCheckedModeBanner: false,
      
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const LandingPage();
  }
}


