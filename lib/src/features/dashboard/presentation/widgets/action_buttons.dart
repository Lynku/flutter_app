
import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onAddMeal;
  final VoidCallback onAddBurned;

  const ActionButtons({
    super.key,
    required this.onAddMeal,
    required this.onAddBurned,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(onPressed: onAddMeal, child: const Text('Add Meal Calories')),
        ElevatedButton(onPressed: onAddBurned, child: const Text('Add Burned')),
      ],
    );
  }
}
