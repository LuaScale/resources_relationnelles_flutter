import 'package:universal_html/html.dart' as html;
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:resources_relationnelles_flutter/classes/stats.dart';
import 'dart:typed_data';

class ExportStats extends StatelessWidget {
  final Future<Stats> statsFuture;
  const ExportStats({super.key, required this.statsFuture});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Stats>(
      future: statsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          return ExportButton(stats: snapshot.data!);
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }
}

class ExportButton extends StatelessWidget {
  final Stats stats;
  const ExportButton({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: ElevatedButton(
          child: const Text('Export Stats'),
          onPressed: () async {
            createExcelFile(stats);
          },
        ),
      ),
    );
  }

void createExcelFile(Stats stats) async {
  var excel = Excel.createExcel();
  var sheet = excel['Sheet1'];

  // Append headers for ressourceByCategories
  sheet.appendRow([TextCellValue("Type de Catégorie"), TextCellValue("Ressources de ce type")]);
  for (var item in stats.ressourceByCategories) {
    sheet.appendRow([TextCellValue(item.categoryName), IntCellValue(item.ressourceCount)]);
  }

  // Append headers for ressourceByDays
  sheet.appendRow([TextCellValue("Date de soumission"), TextCellValue("Nombre de ressources Postées")]);
  stats.ressourceByDays.forEach((date, count) {
    sheet.appendRow([TextCellValue(date), IntCellValue(count)]);
  });

  // Generate file bytes
  final bytes = excel.encode();
  
  // Create a Uint8List from bytes
  final blob = html.Blob([Uint8List.fromList(bytes!)], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
  final url = html.Url.createObjectUrlFromBlob(blob);
  
  // Create a temporary anchor element
  final anchor = html.AnchorElement(href: url);
  anchor.setAttribute("download", "filename.xlsx");
  anchor.click();
  
  // Revoke the object URL to free up memory
  html.Url.revokeObjectUrl(url);
}

}
