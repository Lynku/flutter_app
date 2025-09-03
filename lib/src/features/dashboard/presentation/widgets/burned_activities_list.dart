import 'package:flutter/material.dart';

class BurnedActivitiesList extends StatelessWidget {
  final Map<String, double> burnedActivities;
  final Function({String? activityToEdit, double? caloriesToEdit}) onEditBurned;

  const BurnedActivitiesList({
    super.key,
    required this.burnedActivities,
    required this.onEditBurned,
  });

  @override
  Widget build(BuildContext context) {
    if (burnedActivities.isEmpty) return const SizedBox.shrink();
    return Card(
      child: ExpansionTile(
        title: const Text(
          'Burned Activities',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                ...burnedActivities.entries.map(
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
                              onPressed: () => onEditBurned(
                                activityToEdit: entry.key,
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