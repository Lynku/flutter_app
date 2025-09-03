import 'dart:convert';
import 'package:flutter_app/src/core/data/data_saver.dart';
import 'package:http/http.dart' as http;

class DataSaverWeb implements DataSaver {
  @override
  Future<void> saveDailyData(String formattedDate, Map<String, dynamic> data) async {
    final url = Uri.parse('http://127.0.0.1:8080/save_json');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'formattedDate': formattedDate, 'data': data}),
      );

      if (response.statusCode == 200) {
        print('Data sent to server successfully: ${response.body}');
      } else {
        print('Failed to send data to server: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('Error sending data to server: $e');
    }
  }

  @override
  Future<Map<String, dynamic>?> readDailyData(String formattedDate) async {
    final url = Uri.parse('http://127.0.0.1:8080/read_json/$formattedDate');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 404) {
        print('Data not found for $formattedDate');
        return null;
      } else {
        print('Failed to read data from server: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error reading data from server: $e');
      return null;
    }
  }
}