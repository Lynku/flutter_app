import 'package:flutter/material.dart';
import 'package:flutter_app/src/features/meals/data/meal_service.dart';
import 'package:flutter_app/src/features/meals/domain/meal.dart';

class MealsScreen extends StatefulWidget {
  const MealsScreen({super.key});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  final MealService _mealService = MealService();
  List<Meal> _allMeals = [];
  List<Meal> _displayedMeals = [];
  int _mealsPerPage = 10;
  int _currentPage = 0;
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadAllMeals();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadAllMeals() async {
    setState(() {
      _isLoading = true;
    });
    _allMeals = await _mealService.loadMeals();
    _loadMoreMeals();
    setState(() {
      _isLoading = false;
    });
  }

  void _loadMoreMeals() {
    setState(() {
      _isLoading = true;
    });
    final int startIndex = _currentPage * _mealsPerPage;
    final int endIndex = startIndex + _mealsPerPage;
    if (startIndex < _allMeals.length) {
      _displayedMeals.addAll(
        _allMeals.sublist(
          startIndex,
          endIndex > _allMeals.length ? _allMeals.length : endIndex,
        ),
      );
      _currentPage++;
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoading) {
      _loadMoreMeals();
    }
  }

  void _showMealDetails(Meal meal) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MealDetailScreen(meal: meal),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meals'),
      ),
      body: _isLoading && _displayedMeals.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _scrollController,
              itemCount: _displayedMeals.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _displayedMeals.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                final meal = _displayedMeals[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () => _showMealDetails(meal),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Image.network(
                            meal.imageUrl,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  meal.title,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Text('Calories: ${meal.calories} kcal'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class MealDetailScreen extends StatelessWidget {
  final Meal meal;

  const MealDetailScreen({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(meal.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(meal.imageUrl, fit: BoxFit.cover, width: double.infinity, height: 200),
            const SizedBox(height: 16),
            Text(
              'Calories: ${meal.calories} kcal',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Vitamins: ${meal.vitamins}'),
            const SizedBox(height: 8),
            Text('Proteins: ${meal.proteins}'),
            const SizedBox(height: 16),
            const Text(
              'Ingredients:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ...meal.items.map((item) => Text('- $item')),
            const SizedBox(height: 16),
            const Text(
              'Preparation:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(meal.preparation),
          ],
        ),
      ),
    );
  }
}