import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  int _bottomNavIndex = 3; // Settings active
  bool _isDarkMode = false;
  String _selectedLanguage = 'English (US)';
  String _selectedUnit = 'Metric (kg, mm)';

  // Unit options
  final List<String> _unitOptions = [
    'Metric (kg, mm)',
    'Imperial (lb, in)',
    'Metric (ton, m)',
  ];

  // Language options
  final List<String> _languageOptions = [
    'English (US)',
    'English (UK)',
    'Spanish',
    'French',
    'German',
    'Hindi',
    'Chinese',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF8FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF004AC6)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Color(0xFF004AC6),  
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
       
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Card
            const SizedBox(height: 24),

            // Section 1: Preferences
            _buildSectionHeader('PREFERENCES'),
            const SizedBox(height: 8),
            _buildGroupedCard([
              // Dark Mode Switch Row
              _buildSettingRow(
                icon: Icons.dark_mode_outlined,
                title: 'Dark Mode',
                subtitle: 'Toggle light or dark interface',
                trailing: Switch(
                  value: _isDarkMode,
                  activeColor: const Color(0xFF004AC6),
                  onChanged: (val) {
                    setState(() {
                      _isDarkMode = val;
                    });
                    _showSnackBar('Dark mode ${val ? 'enabled' : 'disabled'}');
                  },
                ),
                showDivider: true,
                onTap: () {
                  setState(() {
                    _isDarkMode = !_isDarkMode;
                  });
                  _showSnackBar(
                    'Dark mode ${_isDarkMode ? 'enabled' : 'disabled'}',
                  );
                },
              ),
              // Default Units
             
              // Language
              _buildSettingRow(
                icon: Icons.language,
                title: 'Language',
                subtitle: _selectedLanguage,
                trailing: const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF434655),
                ),
                showDivider: false,
                onTap: () {
                  _showLanguageSelectionDialog();
                },
              ),
            ]),
            const SizedBox(height: 24),

            // Section 2: Support & Info
            _buildSectionHeader('SUPPORT & INFO'),
            const SizedBox(height: 8),
            _buildGroupedCard([
              _buildSettingRow(
                icon: Icons.info_outline,
                title: 'About Milen traders',
                trailing: const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF434655),
                ),
                showDivider: true,
                onTap: () {
                  _showAboutDialog();
                },
              ),
              _buildSettingRow(
                icon: Icons.shield_outlined,
                title: 'Privacy Policy',
                trailing: const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF434655),
                ),
                showDivider: true,
                onTap: () {
                  _launchURL('https://your-privacy-policy-url.com');
                },
              ),
              _buildSettingRow(
                icon: Icons.star_outline,
                title: 'Rate App',
                trailing: const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF434655),
                ),
                showDivider: true,
                onTap: () {
                  _rateApp();
                },
              ),
              _buildSettingRow(
                icon: Icons.share_outlined,
                title: 'Share App',
                trailing: const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF434655),
                ),
                showDivider: false,
                onTap: () {
                  _shareApp();
                },
              ),
            ]),
            const SizedBox(height: 28),

            // Version Footer
            Center(
              child: Column(
                children: const [
                  Text(
                    'MetalCalc Pro v2.4.0 (Build 892)',
                    style: TextStyle(
                      color: Color(0xFF737686),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '© 2024 Industrial Dynamics Ltd.',
                    style: TextStyle(
                      color: Color(0xFF737686),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFEDEDF9),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround),
          ),
        ),
      ),
    );
  }


  // --- Build Section Header ---
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF004AC6),
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  // --- Build Grouped Card ---
  Widget _buildGroupedCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC3C6D7).withOpacity(0.5)),
      ),
      child: Column(children: children),
    );
  }

  // --- Build Setting Row ---
  Widget _buildSettingRow({
    required IconData icon,
    required String title,
    String? subtitle,
    required Widget trailing,
    bool showDivider = true,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Icon Circle Container
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: const Color(0xFF004AC6), size: 20),
                  ),
                  const SizedBox(width: 14),

                  // Title and Subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF191B23),
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF434655),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Trailing Action/Icon
                  trailing,
                ],
              ),
            ),
            if (showDivider)
              Divider(
                height: 1,
                thickness: 0.5,
                color: const Color(0xFFE1E2ED),
              ),
          ],
        ),
      ),
    );
  }

  // --- Show Unit Selection Dialog ---
  void _showUnitSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Default Units'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _unitOptions.map((unit) {
            return RadioListTile<String>(
              title: Text(unit),
              value: unit,
              groupValue: _selectedUnit,
              onChanged: (value) {
                setState(() {
                  _selectedUnit = value!;
                });
                Navigator.pop(context);
                _showSnackBar('Units updated to $_selectedUnit');
              },
              activeColor: const Color(0xFF004AC6),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  // --- Show Language Selection Dialog ---
  void _showLanguageSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _languageOptions.map((language) {
            return RadioListTile<String>(
              title: Text(language),
              value: language,
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                Navigator.pop(context);
                _showSnackBar('Language updated to $_selectedLanguage');
              },
              activeColor: const Color(0xFF004AC6),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  // --- Show Edit Profile Dialog ---
  void _showEditProfileDialog() {
    final TextEditingController nameController = TextEditingController(
      text: 'Alex Thompson',
    );
    final TextEditingController titleController = TextEditingController(
      text: 'Lead Project Manager',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.work),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('Profile updated successfully!');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF004AC6),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // --- Show Profile Dialog ---
  void _showProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Profile'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Color(0xFF004AC6),
              child: Icon(Icons.person, size: 40, color: Colors.white),
            ),
            SizedBox(height: 12),
            Text(
              'Alex Thompson',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              'Lead Project Manager',
              style: TextStyle(color: Color(0xFF434655)),
            ),
            SizedBox(height: 8),
            Text(
              'Pro Account Active',
              style: TextStyle(
                color: Color(0xFF004AC6),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // --- Show About Dialog ---
  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'Milen traders',
      applicationVersion: 'v2.4.0',
      applicationLegalese: '© 2024 Industrial Dynamics Ltd.',
      children: const [
        SizedBox(height: 8),
        Text(
          'Milen traders is a professional metal weight calculator designed for engineers, architects, and manufacturing professionals.',
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 8),
        Text(
          'Features:\n• Multiple material types\n• Various shapes and profiles\n• Quick unit conversion\n• History tracking',
          style: TextStyle(fontSize: 13),
        ),
      ],
    );
  }

  // --- Launch URL ---
  Future<void> _launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showSnackBar('Could not open URL');
      }
    } catch (e) {
      _showSnackBar('Error opening URL');
    }
  }

  // --- Rate App ---
  void _rateApp() {
    // For iOS, use: https://apps.apple.com/app/idYOUR_APP_ID
    // For Android, use: https://play.google.com/store/apps/details?id=YOUR_PACKAGE_NAME
    _launchURL(
      'https://play.google.com/store/apps/details?id=com.example.metalcalc',
    );
  }

  // --- Share App ---
  void _shareApp() {
    Share.share(
      'Check out Milen traders - The ultimate metal weight calculator app!\n\n'
      'Download now: https://play.google.com/store/apps/details?id=com.example.metalcalc',
      subject: 'MetalCalc Pro - Metal Weight Calculator',
    );
  }

  // --- Show Snackbar ---
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF004AC6),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }
}
