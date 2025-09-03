import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_app/src/core/data/data_saver.dart';

class DataSaverIO implements DataSaver {
  @override
  Future<void> saveDailyData(String formattedDate, Map<String, dynamic> data) async {
    final fileName = 'dashboard_$formattedDate.json';
    final directory = await getApplicationDocumentsDirectory();
    final appDirectory = Directory('${directory.path}/dashboard_data');
    
    if (!await appDirectory.exists()) {
      await appDirectory.create(recursive: true);
    }

    final file = File('${appDirectory.path}/$fileName');

    try {
      await file.writeAsString(json.encode(data));
      print('Data saved to ${file.path}');
    } catch (e) {
      print('Error saving data: $e');
    }
  }

  @override
  Future<Map<String, dynamic>?> readDailyData(String formattedDate) async {
    final fileName = 'dashboard_$formattedDate.json';
    final directory = await getApplicationDocumentsDirectory();
    final appDirectory = Directory('${directory.path}/dashboard_data');
    final file = File('${appDirectory.path}/$fileName');

    if (await file.exists()) {
      try {
        final contents = await file.readAsString();
        return json.decode(contents);
      } catch (e) {
        print('Error reading data: $e');
        return null;
      }
    } else {
      return null;
    }
  }
}