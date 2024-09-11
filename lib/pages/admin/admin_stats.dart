import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:resources_relationnelles_flutter/classes/stats.dart';
import 'package:resources_relationnelles_flutter/widgets/custom_appbar.dart';
import 'package:resources_relationnelles_flutter/widgets/custom_sidebar.dart';
import 'package:resources_relationnelles_flutter/widgets/export_stats.dart';
import 'package:resources_relationnelles_flutter/widgets/stats_widget.dart';

Future<Stats> fetchStats() async {
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
    print('Failed to load ressource: ${response.statusCode}');
    throw Exception('Failed to load ressource');
  }
}

class AdminStats extends StatelessWidget {
  const AdminStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: Text('Admin Stats'),
      ),
      drawer: const CustomSidebar(),
      body: Column(
        children: [
          Expanded(
            child: StatsWidget(statsFuture: fetchStats()),
          ),
          Container(
            color: const Color(0xff45b39d),
            height: 50,
            child: ExportStats(statsFuture: fetchStats()),
          ),
        ],
      ),
    );
  }
}



