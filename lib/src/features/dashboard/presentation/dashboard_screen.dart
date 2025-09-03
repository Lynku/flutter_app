
import 'package:flutter/material.dart';
import 'package:flutter_app/src/features/dashboard/presentation/widgets/action_buttons.dart';
import 'package:flutter_app/src/features/dashboard/presentation/widgets/calorie_summary_card.dart';
import 'package:flutter_app/src/features/dashboard/presentation/widgets/meals_donut_chart.dart';
import 'package:flutter_app/src/features/dashboard/presentation/widgets/water_tracker_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // State
  DateTime _selectedDate = DateTime.now();
  int _waterGlasses = 0;
  final Map<String, double> _burnedActivities = {};
  final Map<String, double> _mealCalories = {
    'Breakfast': 0,
    'Lunch': 0,
    'Dinner': 0,
  };

  final Map<String, Color> _mealColors = {
    'Breakfast': Colors.blue,
    'Lunch': Colors.green,
    'Dinner': Colors.orange,
  };
  final List<Color> _availableColors = [Colors.purple, Colors.red, Colors.teal, Colors.pink, Colors.amber];

  // Calculated values
  double get _totalCaloriesConsumed => _mealCalories.values.fold(0, (a, b) => a + b);
  double get _totalCaloriesBurned => _burnedActivities.values.fold(0, (a, b) => a + b);
  double get _netCalories => _totalCaloriesConsumed - _totalCaloriesBurned;

  // Methods
  void _clearDataForNewDate() {
    setState(() {
      _waterGlasses = 0;
      _burnedActivities.clear();
      _mealCalories.updateAll((key, value) => 0);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020), 
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _clearDataForNewDate();
    }
  }

  void _addWater() => setState(() => _waterGlasses++);
  void _subtractWater() => setState(() => _waterGlasses = _waterGlasses > 0 ? _waterGlasses - 1 : 0);

  void _showAddBurnedDialog() {
    final activityController = TextEditingController();
    final calorieController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Burned Calories'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: activityController, decoration: const InputDecoration(labelText: 'Activity (e.g., Running)')),
            TextField(controller: calorieController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Calories')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final activity = activityController.text;
              final calories = double.tryParse(calorieController.text) ?? 0;
              if (activity.isNotEmpty && calories > 0) {
                setState(() {
                  _burnedActivities[activity] = (_burnedActivities[activity] ?? 0) + calories;
                });
              }
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAddMealDialog() {
    final calorieController = TextEditingController();
    final newMealController = TextEditingController();
    String? selectedMeal = _mealCalories.keys.first;
    bool isNewMeal = false;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Meal Calories'),
        content: StatefulBuilder(
          builder: (context, setDialogState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isNewMeal)
                DropdownButton<String>(
                  value: selectedMeal,
                  items: _mealCalories.keys.map((meal) => DropdownMenuItem(value: meal, child: Text(meal))).toList(),
                  onChanged: (value) => setDialogState(() => selectedMeal = value),
                ),
              if (isNewMeal)
                TextField(controller: newMealController, decoration: const InputDecoration(labelText: 'New Meal Name')),
              CheckboxListTile(
                title: const Text('Add new meal type'),
                value: isNewMeal,
                onChanged: (value) => setDialogState(() => isNewMeal = value!),
              ),
              TextField(controller: calorieController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Calories')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final calories = double.tryParse(calorieController.text) ?? 0;
              if (calories <= 0) return Navigator.of(context).pop();

              setState(() {
                if (isNewMeal) {
                  final newMealName = newMealController.text;
                  if (newMealName.isNotEmpty && !_mealCalories.containsKey(newMealName)) {
                    _mealCalories[newMealName] = calories;
                    _mealColors[newMealName] = _availableColors[_mealCalories.length % _availableColors.length];
                  }
                } else if (selectedMeal != null) {
                  _mealCalories[selectedMeal!] = (_mealCalories[selectedMeal] ?? 0) + calories;
                }
              });
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}";
    return Scaffold(
      appBar: AppBar(
        title: TextButton.icon(
          icon: const Icon(Icons.calendar_today, color: Colors.white),
          label: Text('Dashboard for $formattedDate', style: const TextStyle(color: Colors.white)),
          onPressed: () => _selectDate(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CalorieSummaryCard(
                totalCaloriesConsumed: _totalCaloriesConsumed,
                caloriesBurned: _totalCaloriesBurned,
                netCalories: _netCalories,
              ),
              const SizedBox(height: 20),
              MealsDonutChart(mealCalories: _mealCalories, mealColors: _mealColors),
              const SizedBox(height: 20),
              _buildBurnedActivitiesList(),
              const SizedBox(height: 20),
              WaterTrackerCard(waterGlasses: _waterGlasses, onAddWater: _addWater, onSubtractWater: _subtractWater),
              const SizedBox(height: 20),
              ActionButtons(onAddMeal: _showAddMealDialog, onAddBurned: _showAddBurnedDialog),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBurnedActivitiesList() {
    if (_burnedActivities.isEmpty) return const SizedBox.shrink();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Burned Activities', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ..._burnedActivities.entries.map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text(entry.key), Text('${entry.value.toStringAsFixed(0)} kcal')],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
