import 'package:flutter/material.dart';
import 'package:flutter_app/src/features/meals/domain/meal.dart';

class MealDetailScreen extends StatelessWidget {
  final Meal meal;

  const MealDetailScreen({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(meal.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(meal.imageUrl, fit: BoxFit.cover, width: double.infinity, height: 200),
            const SizedBox(height: 16),
            Text(
              'Calories per portion: ${meal.calories} kcal',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Vitamins: ${meal.vitamins}'),
            const SizedBox(height: 8),
            Text('Proteins: ${meal.proteins}'),
            const SizedBox(height: 16),
            const Text(
              'Ingredients:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ...meal.items.map((item) => Text('- $item')),
            const SizedBox(height: 16),
            const Text(
              'Preparation:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(meal.preparation),
          ],
        ),
      ),
    );
  }
}
