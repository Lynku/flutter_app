import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/src/core/theme/theme_provider.dart';
import 'package:flutter_app/src/core/theme/app_theme.dart';

class SettingsTab extends ConsumerStatefulWidget {
  const SettingsTab({super.key});

  @override
  ConsumerState<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends ConsumerState<SettingsTab> {
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    });
  }

  Future<void> _saveNotificationsSetting(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', value);
    setState(() {
      _notificationsEnabled = value;
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
    final currentThemeMode = ref.watch(themeProvider);

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
          trailing: DropdownButton<AppThemeMode>(
            value: currentThemeMode,
            onChanged: (AppThemeMode? newMode) {
              if (newMode != null) {
                ref.read(themeProvider.notifier).setTheme(newMode);
              }
            },
            items: AppThemeMode.values
                .map<DropdownMenuItem<AppThemeMode>>((AppThemeMode mode) {
              return DropdownMenuItem<AppThemeMode>(
                value: mode,
                child: Text(mode.toDisplayString()),
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