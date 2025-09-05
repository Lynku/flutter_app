import 'package:flutter_app/src/core/data/data_saver.dart';
import 'package:flutter_app/src/features/meals/domain/meal.dart';
import 'package:flutter_app/src/core/utils/date_formatter.dart'; // Import the new utility

class DashboardService {
  final DataSaver _dataSaver = DataSaver();

  Future<void> addMealToDashboard(Meal meal) async {
    final selectedDate = DateTime.now();
    final formattedDate = DateFormatter.toYYYYMMDD(selectedDate);

    final dailyData = await _dataSaver.readDailyData(formattedDate) ??
        {
          'date': formattedDate,
          'waterGlasses': 0,
          'burnedActivities': <String, double>{},
          'mealCalories': <String, double>{},
        };

    final mealCalories = (dailyData['mealCalories'] as Map).cast<String, double>();

    if (mealCalories.containsKey(meal.title)) {
      mealCalories[meal.title] = mealCalories[meal.title]! + meal.calories.toDouble();
    } else {
      mealCalories[meal.title] = meal.calories.toDouble();
    }
    dailyData['mealCalories'] = mealCalories;

    await _dataSaver.saveDailyData(formattedDate, dailyData);
  }
}
