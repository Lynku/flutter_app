import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_app/src/core/data/data_saver_io.dart';
import 'package:flutter_app/src/core/data/data_saver_web.dart';

abstract class DataSaver {
  Future<void> saveDailyData(String formattedDate, Map<String, dynamic> data);
  Future<Map<String, dynamic>?> readDailyData(String formattedDate);

  factory DataSaver() {
    if (kIsWeb) {
      return DataSaverWeb();
    } else {
      return DataSaverIO();
    }
  }
}