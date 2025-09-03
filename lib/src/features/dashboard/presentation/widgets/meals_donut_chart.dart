
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MealsDonutChart extends StatelessWidget {
  final Map<String, double> mealCalories;
  final Map<String, Color> mealColors;

  const MealsDonutChart({
    super.key,
    required this.mealCalories,
    required this.mealColors,
  });

  @override
  Widget build(BuildContext context) {
    final hasData = mealCalories.values.any((v) => v > 0);
    return SizedBox(
      height: 200,
      child: hasData
          ? PieChart(
              PieChartData(
                pieTouchData: PieTouchData(touchCallback: (FlTouchEvent event, pieTouchResponse) {}),
                centerSpaceRadius: 60,
                sectionsSpace: 2,
                sections: mealCalories.entries.map((entry) {
                  return PieChartSectionData(
                    color: mealColors[entry.key],
                    value: entry.value,
                    title: '${entry.value.toStringAsFixed(0)} ${entry.key}',
                    radius: 50,
                    titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                  );
                }).toList(),
              ),
            )
          : const Center(child: Text('No meal data yet. Add calories!')),
    );
  }
}
