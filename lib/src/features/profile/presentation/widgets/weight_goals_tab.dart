import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeightGoalsTab extends StatefulWidget {
  const WeightGoalsTab({super.key});

  @override
  State<WeightGoalsTab> createState() => _WeightGoalsTabState();
}

class _WeightGoalsTabState extends State<WeightGoalsTab> {
  final TextEditingController _currentWeightController = TextEditingController();
  final TextEditingController _targetWeightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadWeights();
  }

  @override
  void dispose() {
    _currentWeightController.dispose();
    _targetWeightController.dispose();
    super.dispose();
  }

  Future<void> _loadWeights() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentWeightController.text = prefs.getString('currentWeight') ?? '';
      _targetWeightController.text = prefs.getString('targetWeight') ?? '';
    });
  }

  Future<void> _saveWeights() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentWeight', _currentWeightController.text);
    await prefs.setString('targetWeight', _targetWeightController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Weights saved!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _currentWeightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Current Weight (kg)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _targetWeightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Target Weight (kg)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton(
              onPressed: _saveWeights,
              child: const Text('Save Weights'),
            ),
          ),
        ],
      ),
    );
  }
}