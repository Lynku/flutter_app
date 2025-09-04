import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  bool _notificationsEnabled = true;
  String _selectedTheme = 'System'; // Default theme

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      _selectedTheme = prefs.getString('selectedTheme') ?? 'System';
    });
  }

  Future<void> _saveNotificationsSetting(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', value);
    setState(() {
      _notificationsEnabled = value;
    });
  }

  Future<void> _saveThemeSetting(String? value) async {
    if (value == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedTheme', value);
    setState(() {
      _selectedTheme = value;
    });
  }

  void _createBackup() {
    // Placeholder for backup logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Backup functionality not yet implemented.')),
    );
  }

  void _showLegalInfo() {
    // Placeholder for legal info display
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Legal Information'),
        content: const Text('This is placeholder legal information.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        SwitchListTile(
          title: const Text('Enable Notifications'),
          value: _notificationsEnabled,
          onChanged: _saveNotificationsSetting,
        ),
        ListTile(
          title: const Text('App Theme'),
          trailing: DropdownButton<String>(
            value: _selectedTheme,
            onChanged: _saveThemeSetting,
            items: <String>['System', 'Light', 'Dark']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        const Divider(),
        ListTile(
          title: const Text('Create Backup'),
          onTap: _createBackup,
          trailing: const Icon(Icons.cloud_upload),
        ),
        ListTile(
          title: const Text('Legal'),
          onTap: _showLegalInfo,
          trailing: const Icon(Icons.info_outline),
        ),
      ],
    );
  }
}