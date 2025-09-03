import 'package:flutter/material.dart';
import 'package:flutter_app/src/features/dashboard/presentation/widgets/action_buttons.dart';
import 'package:flutter_app/src/features/dashboard/presentation/widgets/calorie_summary_card.dart';
import 'package:flutter_app/src/features/dashboard/presentation/widgets/meals_donut_chart.dart';
import 'package:flutter_app/src/features/dashboard/presentation/widgets/water_tracker_card.dart';
import 'package:flutter_app/src/core/data/data_saver.dart';
import 'package:flutter_app/src/features/dashboard/presentation/widgets/burned_activities_list.dart';
import 'package:flutter_app/src/features/dashboard/presentation/widgets/meal_list.dart';

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
  final List<Color> _availableColors = [
    Colors.purple,
    Colors.red,
    Colors.teal,
    Colors.pink,
    Colors.amber,
  ];

  late DataSaver _dataSaver;

  @override
  void initState() {
    super.initState();
    _dataSaver = DataSaver();
    _loadDailyData();
  }

  // Calculated values
  double get _totalCaloriesConsumed =>
      _mealCalories.values.fold(0, (a, b) => a + b);
  double get _totalCaloriesBurned =>
      _burnedActivities.values.fold(0, (a, b) => a + b);
  double get _netCalories => _totalCaloriesConsumed - _totalCaloriesBurned;

  // Methods
  Future<void> _loadDailyData() async {
    final formattedDate =
        "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}";
    final loadedData = await _dataSaver.readDailyData(formattedDate);

    setState(() {
      if (loadedData != null) {
        _waterGlasses = loadedData['waterGlasses'] ?? 0;
        _burnedActivities.clear();
        (loadedData['burnedActivities'] as Map<dynamic, dynamic>).forEach((
          key,
          value,
        ) {
          _burnedActivities[key.toString()] = value.toDouble();
        });
        _mealCalories.clear();
        (loadedData['mealCalories'] as Map<dynamic, dynamic>).forEach((
          key,
          value,
        ) {
          _mealCalories[key.toString()] = value.toDouble();
        });
      } else {
        // If no data for today, clear current state
        _waterGlasses = 0;
        _burnedActivities.clear();
        _mealCalories.updateAll((key, value) => 0);
      }
    });
  }

  Future<void> _saveDailyData() async {
    final formattedDate =
        "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}";
    final data = {
      'date': formattedDate,
      'waterGlasses': _waterGlasses,
      'burnedActivities': _burnedActivities,
      'mealCalories': _mealCalories,
    };

    await _dataSaver.saveDailyData(formattedDate, data);
  }

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
      firstDate: DateTime(2025),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      // Save data for the previously selected date before changing to a new date
      await _saveDailyData();
      setState(() {
        _selectedDate = picked;
      });
      await _loadDailyData(); // Load data for the newly selected date
    }
  }

  void _addWater() => setState(() {
    _waterGlasses++;
    _saveDailyData();
  });
  void _subtractWater() => setState(() {
    _waterGlasses = _waterGlasses > 0 ? _waterGlasses - 1 : 0;
    _saveDailyData();
  });

  void _showAddBurnedDialog({String? activityToEdit, double? caloriesToEdit}) {
    final activityController = TextEditingController(text: activityToEdit);
    final calorieController = TextEditingController(
      text: caloriesToEdit?.toStringAsFixed(0),
    );
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          activityToEdit == null
              ? 'Add Burned Calories'
              : 'Edit Burned Calories',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: activityController,
              decoration: const InputDecoration(
                labelText: 'Activity (e.g., Running)',
              ),
            ),
            TextField(
              controller: calorieController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Calories'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          if (activityToEdit !=
              null) // Show delete button only for existing activities
            TextButton(
              onPressed: () async {
                setState(() {
                  _burnedActivities.remove(activityToEdit);
                });
                await _saveDailyData();
                Navigator.of(context).pop();
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ElevatedButton(
            onPressed: () async {
              final activity = activityController.text;
              final calories = double.tryParse(calorieController.text) ?? 0;
              if (activity.isNotEmpty && calories > 0) {
                setState(() {
                  if (activityToEdit != null && activityToEdit != activity) {
                    // If activity name changed, remove old entry
                    _burnedActivities.remove(activityToEdit);
                  }
                  _burnedActivities[activity] = calories;
                });
                await _saveDailyData();
              }
              Navigator.of(context).pop();
            },
            child: Text(activityToEdit == null ? 'Add' : 'Save'),
          ),
        ],
      ),
    );
  }

  void _showAddMealDialog({String? mealToEdit, double? caloriesToEdit}) {
    final calorieController = TextEditingController(
      text: caloriesToEdit?.toStringAsFixed(0),
    );
    final newMealController = TextEditingController();
    String? selectedMeal = mealToEdit ?? _mealCalories.keys.first;
    bool isNewMeal = mealToEdit == null
        ? false
        : !_mealCalories.containsKey(mealToEdit);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          mealToEdit == null ? 'Add Meal Calories' : 'Edit Meal Calories',
        ),
        content: StatefulBuilder(
          builder: (context, setDialogState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isNewMeal &&
                  mealToEdit ==
                      null) // Only show dropdown for adding existing meals
                DropdownButton<String>(
                  value: selectedMeal,
                  items: _mealCalories.keys
                      .map(
                        (meal) =>
                            DropdownMenuItem(value: meal, child: Text(meal)),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setDialogState(() => selectedMeal = value),
                ),
              if (isNewMeal ||
                  mealToEdit !=
                      null) // Show text field for new meal or editing existing
                TextField(
                  controller: newMealController..text = mealToEdit ?? '',
                  decoration: const InputDecoration(labelText: 'Meal Name'),
                  enabled:
                      mealToEdit ==
                      null, // Disable editing meal name for existing meals
                ),
              if (mealToEdit == null) // Only show checkbox for adding new meal
                CheckboxListTile(
                  title: const Text('Add new meal type'),
                  value: isNewMeal,
                  onChanged: (value) =>
                      setDialogState(() => isNewMeal = value!),
                ),
              TextField(
                controller: calorieController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Calories'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          if (mealToEdit != null) // Show delete button only for existing meals
            TextButton(
              onPressed: () async {
                setState(() {
                  _mealCalories.remove(mealToEdit);
                  _mealColors.remove(mealToEdit);
                });
                await _saveDailyData();
                Navigator.of(context).pop();
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ElevatedButton(
            onPressed: () async {
              final calories = double.tryParse(calorieController.text) ?? 0;
              if (calories <= 0) return Navigator.of(context).pop();

              setState(() {
                if (isNewMeal) {
                  final newMealName = newMealController.text;
                  if (newMealName.isNotEmpty &&
                      !_mealCalories.containsKey(newMealName)) {
                    _mealCalories[newMealName] = calories;
                    _mealColors[newMealName] =
                        _availableColors[_mealCalories.length %
                            _availableColors.length];
                  }
                } else if (selectedMeal != null) {
                  _mealCalories[selectedMeal!] =
                      calories; // Set directly for editing
                }
              });
              await _saveDailyData();
            },
            child: Text(mealToEdit == null ? 'Add' : 'Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}";
    return Scaffold(
      appBar: AppBar(
        title: TextButton.icon(
          icon: const Icon(
            Icons.calendar_today,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
          label: Text(
            'Dashboard for $formattedDate',
            style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
          ),
          onPressed: () => _selectDate(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ActionButtons(
                onAddMeal: () =>
                    _showAddMealDialog(), // Call without arguments for adding
                onAddBurned: () =>
                    _showAddBurnedDialog(), // Call without arguments for adding
              ),
              const SizedBox(height: 20),
              CalorieSummaryCard(
                totalCaloriesConsumed: _totalCaloriesConsumed,
                caloriesBurned: _totalCaloriesBurned,
                netCalories: _netCalories,
              ),
              const SizedBox(height: 20),
              MealsDonutChart(
                mealCalories: _mealCalories,
                mealColors: _mealColors,
              ),
              const SizedBox(height: 20),
              WaterTrackerCard(
                waterGlasses: _waterGlasses,
                onAddWater: _addWater,
                onSubtractWater: _subtractWater,
              ),
              const SizedBox(height: 20),
              MealList(
                mealCalories: _mealCalories,
                onEditMeal: _showAddMealDialog,
              ),
              const SizedBox(height: 20),
              BurnedActivitiesList(
                burnedActivities: _burnedActivities,
                onEditBurned: _showAddBurnedDialog,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
