import 'package:flutter/material.dart';
import 'package:flutter_app/src/core/data/data_saver.dart';
import 'package:flutter_app/src/features/meals/data/meal_service.dart';
import 'package:flutter_app/src/features/meals/domain/meal.dart';
import 'package:flutter_app/src/features/meals/presentation/widgets/custom_meal_tab.dart';
import 'package:flutter_app/src/features/meals/presentation/widgets/meal_detail_screen.dart';
import 'package:flutter_app/src/features/meals/presentation/widgets/meals_list_tab.dart';

class MealsScreen extends StatefulWidget {
  const MealsScreen({super.key});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
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
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAllMeals();
    });
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _tabController.dispose();
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

  Future<void> _addMealToDashboard(String mealName, double calories) async {
    try {
      final dataSaver = DataSaver();
      final selectedDate = DateTime.now();
      final formattedDate =
          "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";

      final dailyData = await dataSaver.readDailyData(formattedDate) ??
          {
            'date': formattedDate,
            'waterGlasses': 0,
            'burnedActivities': <String, double>{},
            'mealCalories': <String, double>{},
          };

      final mealCalories = (dailyData['mealCalories'] as Map).cast<String, double>();

      mealCalories[mealName] = calories;
      dailyData['mealCalories'] = mealCalories;

      await dataSaver.saveDailyData(formattedDate, dailyData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$mealName added to today\'s meals'),
        ),
      );
    } catch (e) {
      // Handle errors
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
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Meals'),
            Tab(text: 'Add Custom Meal'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Meals Tab
          MealsListTab(
            displayedMeals: _displayedMeals,
            isLoading: _isLoading,
            scrollController: _scrollController,
            showMealDetails: _showMealDetails,
            addMealToDashboard: _addMealToDashboard,
          ),
          // Custom Meal Tab
          CustomMealTab(
            onSaveMeal: _addMealToDashboard,
            tabController: _tabController,
          ),
        ],
      ),
    );
  }
}