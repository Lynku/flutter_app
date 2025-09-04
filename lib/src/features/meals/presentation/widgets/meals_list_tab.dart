import 'package:flutter/material.dart';
import 'package:flutter_app/src/features/meals/domain/meal.dart';

class MealsListTab extends StatelessWidget {
  final List<Meal> displayedMeals;
  final bool isLoading;
  final ScrollController scrollController;
  final Function(Meal) showMealDetails;
  final Function(Meal) addMealToDashboard;

  const MealsListTab({
    super.key,
    required this.displayedMeals,
    required this.isLoading,
    required this.scrollController,
    required this.showMealDetails,
    required this.addMealToDashboard,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading && displayedMeals.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            controller: scrollController,
            itemCount: displayedMeals.length + (isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == displayedMeals.length) {
                return const Center(child: CircularProgressIndicator());
              }
              final meal = displayedMeals[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () => showMealDetails(meal),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Image.network(
                          meal.imageUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                meal.title,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text('Calories per portion: ${meal.calories} kcal'),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () => addMealToDashboard(meal),
                          tooltip: 'Add to today\'s meals',
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }
}
