import 'package:flutter/material.dart';
import 'package:flutter_app/src/features/meals/domain/meal.dart';

class CustomMealTab extends StatefulWidget {
  final Function(Meal) onSaveMeal;
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
  final _titleController = TextEditingController();
  // final _imageUrlController = TextEditingController(); // Commented out
  final _caloriesController = TextEditingController();
  final _vitaminsController = TextEditingController();
  final _proteinsController = TextEditingController();
  final _itemsController = TextEditingController();
  final _preparationController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    // _imageUrlController.dispose(); // Commented out
    _caloriesController.dispose();
    _vitaminsController.dispose();
    _proteinsController.dispose();
    _itemsController.dispose();
    _preparationController.dispose();
    super.dispose();
  }

  void _saveCustomMeal() {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text;
      // final imageUrl = _imageUrlController.text; // Commented out
      final calories = int.tryParse(_caloriesController.text) ?? 0;
      final vitamins = _vitaminsController.text;
      final proteins = _proteinsController.text;
      final items =
          _itemsController.text.split(',').map((e) => e.trim()).toList();
      final preparation = _preparationController.text;

      if (calories > 0) {
        final newMeal = Meal(
          id: 'm${DateTime.now().millisecondsSinceEpoch}',
          title: title,
          imageUrl: 'https://picsum.photos/id/${DateTime.now().millisecond % 1000}/600/400', // Using a random image
          calories: calories,
          vitamins: vitamins,
          proteins: proteins,
          items: items.where((item) => item.isNotEmpty).toList(),
          preparation: preparation,
        );
        widget.onSaveMeal(newMeal);
        _titleController.clear();
        // _imageUrlController.clear(); // Commented out
        _caloriesController.clear();
        _vitaminsController.clear();
        _proteinsController.clear();
        _itemsController.clear();
        _preparationController.clear();
        // Optionally switch tab or give other feedback
        widget.tabController.animateTo(0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
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
              // TextFormField(
              //   controller: _imageUrlController,
              //   decoration: const InputDecoration(
              //     labelText: 'Image URL',
              //     border: OutlineInputBorder(),
              //   ),
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter an image URL';
              //     }
              //     return null;
              //   },
              // ),
              // const SizedBox(height: 16),
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
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _vitaminsController,
                decoration: const InputDecoration(
                  labelText: 'Vitamins (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _proteinsController,
                decoration: const InputDecoration(
                  labelText: 'Proteins (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _itemsController,
                decoration: const InputDecoration(
                  labelText: 'Items (comma-separated, Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _preparationController,
                decoration: const InputDecoration(
                  labelText: 'Preparation (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveCustomMeal,
                child: const Text('Save Custom Meal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
