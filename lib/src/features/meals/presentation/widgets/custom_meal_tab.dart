import 'package:flutter/material.dart';

class CustomMealTab extends StatefulWidget {
  final Function(String, double) onSaveMeal;
  final TabController tabController;

  const CustomMealTab({
    super.key,
    required this.onSaveMeal,
    required this.tabController,
  });

  @override
  State<CustomMealTab> createState() => _CustomMealTabState();
}

class _CustomMealTabState extends State<CustomMealTab> {
  final _formKey = GlobalKey<FormState>();
  final _mealNameController = TextEditingController();
  final _caloriesController = TextEditingController();

  @override
  void dispose() {
    _mealNameController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  void _saveCustomMeal() {
    if (_formKey.currentState!.validate()) {
      final mealName = _mealNameController.text;
      final calories = double.tryParse(_caloriesController.text) ?? 0;
      if (calories > 0) {
        widget.onSaveMeal(mealName, calories);
        _mealNameController.clear();
        _caloriesController.clear();
        // Optionally switch tab or give other feedback
        widget.tabController.animateTo(0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _mealNameController,
              decoration: const InputDecoration(
                labelText: 'Meal Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a meal name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _caloriesController,
              decoration: const InputDecoration(
                labelText: 'Calories per Portion',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter calories';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveCustomMeal,
              child: const Text('Save Custom Meal'),
            ),
          ],
        ),
      ),
    );
  }
}
