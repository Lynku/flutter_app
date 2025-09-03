import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_app/src/features/meals/domain/meal.dart';

class MealService {
  Future<List<Meal>> loadMeals() async {
    final String response = await rootBundle.loadString('assets/meals.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Meal.fromJson(json)).toList();
  }
}