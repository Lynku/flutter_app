
import 'package:flutter/material.dart';

class WaterTrackerCard extends StatelessWidget {
  final int waterGlasses;
  final VoidCallback onAddWater;
  final VoidCallback onSubtractWater;

  const WaterTrackerCard({
    super.key,
    required this.waterGlasses,
    required this.onAddWater,
    required this.onSubtractWater,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Water Intake', style: TextStyle(fontSize: 18)),
            Row(
              children: [
                IconButton(icon: const Icon(Icons.remove), onPressed: onSubtractWater),
                Text('$waterGlasses glasses', style: const TextStyle(fontSize: 18)),
                IconButton(icon: const Icon(Icons.add), onPressed: onAddWater),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
