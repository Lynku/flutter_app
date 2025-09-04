import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class UserProfileTab extends StatefulWidget {
  const UserProfileTab({super.key});

  @override
  State<UserProfileTab> createState() => _UserProfileTabState();
}

class _UserProfileTabState extends State<UserProfileTab> {
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _uuid = '';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _ageController.text = prefs.getString('age') ?? '';
      _heightController.text = prefs.getString('height') ?? '';
      _emailController.text = prefs.getString('email') ?? '';
      _uuid = prefs.getString('uuid') ?? const Uuid().v4();
      prefs.setString('uuid', _uuid); // Save new UUID if generated
    });
  }

  Future<void> _saveUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('age', _ageController.text);
    await prefs.setString('height', _heightController.text);
    await prefs.setString('email', _emailController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User profile saved!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('UUID: $_uuid'),
          const SizedBox(height: 16),
          TextField(
            controller: _ageController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Age',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _heightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Height (cm)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
        
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton(
              onPressed: _saveUserProfile,
              child: const Text('Save Profile'),
            ),
          ),
        ],
      ),
    );
  }
}