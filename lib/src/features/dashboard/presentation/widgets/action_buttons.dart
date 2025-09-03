
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
        SizedBox(
          width: 150,
          height: 55,
          child: ElevatedButton(
            onPressed: onAddMeal,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: const Text('Add Meal'),
          ),
        ),
        SizedBox(
          width: 150,
          height: 55,
          child: ElevatedButton(
            onPressed: onAddBurned,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: const Text('Add Burned'),
          ),
        ),
      ],
    );
  }
}
