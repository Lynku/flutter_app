
import 'package:flutter/material.dart';

class CalorieSummaryCard extends StatelessWidget {
  final double totalCaloriesConsumed;
  final double caloriesBurned;
  final double netCalories;

  const CalorieSummaryCard({
    super.key,
    required this.totalCaloriesConsumed,
    required this.caloriesBurned,
    required this.netCalories,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _summaryText('Consumed', totalCaloriesConsumed.toStringAsFixed(0)),
            const Text('-', style: TextStyle(fontSize: 24)),
            _summaryText('Burned', caloriesBurned.toStringAsFixed(0)),
            const Text('=', style: TextStyle(fontSize: 24)),
            _summaryText('Net', netCalories.toStringAsFixed(0), isBold: true),
          ],
        ),
      ),
    );
  }

  Widget _summaryText(String label, String value, {bool isBold = false}) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        Text(value, style: TextStyle(fontSize: 22, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }
}
