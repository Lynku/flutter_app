import 'package:flutter/material.dart';

class MealList extends StatelessWidget {
  final Map<String, double> mealCalories;
  final Function({String? mealToEdit, double? caloriesToEdit}) onEditMeal;

  const MealList({
    super.key,
    required this.mealCalories,
    required this.onEditMeal,
  });

  @override
  Widget build(BuildContext context) {
    if (mealCalories.isEmpty) return const SizedBox.shrink();
    return Card(
      child: ExpansionTile(
        title: const Text(
          'Meal Calories',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                ...mealCalories.entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(entry.key),
                        Row(
                          children: [
                            Text('${entry.value.toStringAsFixed(0)} kcal'),
                            IconButton(
                              icon: const Icon(Icons.edit, size: 18),
                              onPressed: () => onEditMeal(
                                mealToEdit: entry.key,
                                caloriesToEdit: entry.value,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}