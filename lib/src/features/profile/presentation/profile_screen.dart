
import 'package:flutter/material.dart';
import 'package:flutter_app/src/features/profile/presentation/widgets/weight_goals_tab.dart';
import 'package:flutter_app/src/features/profile/presentation/widgets/user_profile_tab.dart';
import 'package:flutter_app/src/features/profile/presentation/widgets/settings_tab.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Weight Goals'),
            Tab(text: 'User Profile'),
            Tab(text: 'Settings'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          WeightGoalsTab(),
          UserProfileTab(),
          SettingsTab(),
        ],
      ),
    );
  }
}
