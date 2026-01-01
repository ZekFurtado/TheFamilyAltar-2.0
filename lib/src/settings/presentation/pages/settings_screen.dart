import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import '../../../authentication/presentation/bloc/authentication_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  ThemeMode _currentThemeMode = ThemeMode.light;
  Locale _currentLocale = const Locale('en', '');
  bool _isLoading = true;

  final Map<String, String> _languageNames = {
    'en': 'English',
    'hi': 'हिन्दी (Hindi)',
    'mr': 'मराठी (Marathi)',
    'gu': 'ગુજરાતી (Gujarati)',
  };

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // Load theme mode
    final themeIndex = prefs.getInt('theme_mode') ?? 0;
    _currentThemeMode = ThemeMode.values[themeIndex];

    // Load locale
    final languageCode = prefs.getString('language_code') ?? 'en';
    _currentLocale = Locale(languageCode, '');

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveThemeMode(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_mode', themeMode.index);
    setState(() {
      _currentThemeMode = themeMode;
    });

    // TODO: Trigger app theme change
    // This would require a state management solution for theme
  }

  Future<void> _saveLanguage(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
    setState(() {
      _currentLocale = locale;
    });

    // TODO: Trigger app locale change
    // This would require a state management solution for locale
  }

  void _showLanguageBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Select Language',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 20),
            ..._languageNames.entries.map((entry) => ListTile(
                  leading: Radio<String>(
                    value: entry.key,
                    groupValue: _currentLocale.languageCode,
                    onChanged: (value) {
                      if (value != null) {
                        _saveLanguage(Locale(value, ''));
                        Navigator.pop(context);
                      }
                    },
                  ),
                  title: Text(entry.value),
                  onTap: () {
                    _saveLanguage(Locale(entry.key, ''));
                    Navigator.pop(context);
                  },
                )),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showThemeBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Select Theme',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Radio<ThemeMode>(
                value: ThemeMode.light,
                groupValue: _currentThemeMode,
                onChanged: (value) {
                  if (value != null) {
                    _saveThemeMode(value);
                    Navigator.pop(context);
                  }
                },
              ),
              title: const Text('Light'),
              trailing: const Icon(Icons.light_mode),
              onTap: () {
                _saveThemeMode(ThemeMode.light);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Radio<ThemeMode>(
                value: ThemeMode.dark,
                groupValue: _currentThemeMode,
                onChanged: (value) {
                  if (value != null) {
                    _saveThemeMode(value);
                    Navigator.pop(context);
                  }
                },
              ),
              title: const Text('Dark'),
              trailing: const Icon(Icons.dark_mode),
              onTap: () {
                _saveThemeMode(ThemeMode.dark);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Radio<ThemeMode>(
                value: ThemeMode.system,
                groupValue: _currentThemeMode,
                onChanged: (value) {
                  if (value != null) {
                    _saveThemeMode(value);
                    Navigator.pop(context);
                  }
                },
              ),
              title: const Text('System'),
              trailing: const Icon(Icons.auto_mode),
              onTap: () {
                _saveThemeMode(ThemeMode.system);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _signOut() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // context.read<AuthenticationBloc>().add(const SignOutUserEvent());
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/home',
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to permanently delete your account?\n\n'
          'This action cannot be undone and will delete:\n'
          '• Your profile information\n'
          '• Your reading history\n'
          '• Your streaks and progress\n'
          '• All your data\n\n'
          'You will be signed out immediately.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // context.read<AuthenticationBloc>().add(const DeleteAccountEvent());
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/home',
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }

  String _getThemeModeText(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  @override
  Widget build(BuildContext context) {
    // return BlocListener<AuthenticationBloc, AuthenticationState>(
    //   listener: (context, state) {
    //     if (state is DeletingAccount) {
    //       showDialog(
    //         context: context,
    //         barrierDismissible: false,
    //         builder: (context) => const AlertDialog(
    //           content: Row(
    //             children: [
    //               CircularProgressIndicator(),
    //               SizedBox(width: 20),
    //               Text('Deleting account...'),
    //             ],
    //           ),
    //         ),
    //       );
    //     } else if (state is AccountDeleted) {
    //       Navigator.of(context).pop(); // Close loading dialog
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         const SnackBar(
    //           content: Text('Account deleted successfully'),
    //           backgroundColor: Colors.green,
    //         ),
    //       );
    //     } else if (state is AuthenticationError) {
    //       Navigator.of(context).pop(); // Close any loading dialogs
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(
    //           content: Text('Error: ${state.message}'),
    //           backgroundColor: Colors.red,
    //         ),
    //       );
    //     }
    //   },
    //   child: Scaffold(
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Appearance Section
                  _buildSectionHeader('Appearance'),
                  const SizedBox(height: 8),
                  _buildSettingCard(
                    icon: Icons.palette,
                    title: 'Theme',
                    subtitle: _getThemeModeText(_currentThemeMode),
                    onTap: _showThemeBottomSheet,
                  ),
                  const SizedBox(height: 8),
                  _buildSettingCard(
                    icon: Icons.language,
                    title: 'Language',
                    subtitle: _languageNames[_currentLocale.languageCode] ??
                        'English',
                    onTap: _showLanguageBottomSheet,
                  ),

                  const SizedBox(height: 32),

                  // Account Section
                  _buildSectionHeader('Account'),
                  const SizedBox(height: 8),
                  _buildSettingCard(
                    icon: Icons.person,
                    title: 'Profile',
                    subtitle: 'Manage your profile information',
                    onTap: () {
                      // TODO: Navigate to profile screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Profile screen coming soon!'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildSettingCard(
                    icon: Icons.logout,
                    title: 'Sign Out',
                    subtitle: 'Sign out of your account',
                    onTap: _signOut,
                    isDestructive: true,
                  ),
                  const SizedBox(height: 8),
                  _buildSettingCard(
                    icon: Icons.delete_forever,
                    title: 'Delete Account',
                    subtitle: 'Permanently delete your account and all data',
                    onTap: _deleteAccount,
                    isDestructive: true,
                  ),

                  const SizedBox(height: 32),

                  // About Section
                  _buildSectionHeader('About'),
                  const SizedBox(height: 8),
                  _buildSettingCard(
                    icon: Icons.info,
                    title: 'About The Family Altar',
                    subtitle: 'Version 1.0.0',
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'The Family Altar',
                        applicationVersion: '1.0.0',
                        applicationIcon: const Icon(Icons.auto_stories),
                        children: [
                          const Text(
                            'A spiritual companion for daily Bible reading and prayer.',
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Content provided by Voice of God Recordings Inc.',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildSettingCard(
                    icon: Icons.attribution,
                    title: 'Credits',
                    subtitle: 'Acknowledgments and attributions',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Credits'),
                          content: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Copyright Owner',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Voice of God Recordings Inc.',
                                  style: TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Biblical content, sermons, and spiritual materials provided by Voice of God Recordings Inc.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                /*InkWell(
                                  onTap: () {
                                    launchUrl(Uri.parse(
                                        "https://bibleway.org/sermons/#:~:text=Content%20on%20this%20site%20is%20covered%20under%20a%20Creative%20Commons%20License%20BY%2DNC%2DND"));
                                  },
                                  child: const Text(
                                      "Click here for more information"),
                                ),*/
                                const SizedBox(height: 16),
                                const Text(
                                  'Development Team',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'ZionSphere Team',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDestructive
                ? Theme.of(context).colorScheme.error.withValues(alpha: 0.1)
                : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isDestructive
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.primary,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDestructive
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.onSurface,
              ),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.7),
              ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }
}
