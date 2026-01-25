import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart';
import '../../providers/theme_provider.dart';
import '../../services/analytics_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _emailUpdates = true;
  String _currency = 'INR';
  String _language = 'English';

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // General Section
            _buildSectionTitle("General"),
            _buildSettingTile(
              icon: Icons.notifications_outlined,
              title: "Push Notifications",
              subtitle: "Get notified about new cars and offers",
              trailing: Switch(
                value: _notifications,
                onChanged: (v) => setState(() => _notifications = v),
                activeColor: AppColors.primaryAccent,
              ),
            ),
            _buildSettingTile(
              icon: Icons.dark_mode_outlined,
              title: "Dark Mode",
              subtitle: "Switch to dark theme",
              trailing: Switch(
                value: themeProvider.isDarkMode,
                onChanged: (v) async {
                  await themeProvider.toggleTheme();
                  await AnalyticsService.logCustomEvent(
                    'theme_changed',
                    {'theme': v ? 'dark' : 'light'},
                  );
                },
                activeColor: AppColors.primaryAccent,
              ),
            ),
            _buildSettingTile(
              icon: Icons.email_outlined,
              title: "Email Updates",
              subtitle: "Receive weekly newsletters",
              trailing: Switch(
                value: _emailUpdates,
                onChanged: (v) => setState(() => _emailUpdates = v),
                activeColor: AppColors.primaryAccent,
              ),
            ),

            // Preferences Section
            _buildSectionTitle("Preferences"),
            _buildSettingTile(
              icon: Icons.currency_rupee,
              title: "Currency",
              subtitle: _currency,
              onTap: () => _showCurrencyPicker(),
            ),
            _buildSettingTile(
              icon: Icons.language,
              title: "Language",
              subtitle: _language,
              onTap: () => _showLanguagePicker(),
            ),
            _buildSettingTile(
              icon: Icons.location_on_outlined,
              title: "Location",
              subtitle: "Bangalore, India",
              onTap: () {},
            ),

            // Account Section
            _buildSectionTitle("Account"),
            _buildSettingTile(
              icon: Icons.person_outline,
              title: "Edit Profile",
              onTap: () {},
            ),
            _buildSettingTile(
              icon: Icons.lock_outline,
              title: "Change Password",
              onTap: () {},
            ),
            _buildSettingTile(
              icon: Icons.security,
              title: "Privacy Settings",
              onTap: () {},
            ),

            // Support Section
            _buildSectionTitle("Support"),
            _buildSettingTile(
              icon: Icons.help_outline,
              title: "Help Center",
              onTap: () {},
            ),
            _buildSettingTile(
              icon: Icons.chat_bubble_outline,
              title: "Live Chat",
              onTap: () {},
            ),
            _buildSettingTile(
              icon: Icons.description_outlined,
              title: "Terms & Conditions",
              onTap: () {},
            ),
            _buildSettingTile(
              icon: Icons.privacy_tip_outlined,
              title: "Privacy Policy",
              onTap: () {},
            ),

            // App Info
            _buildSectionTitle("About"),
            _buildSettingTile(
              icon: Icons.info_outline,
              title: "App Version",
              subtitle: "1.0.0",
            ),
            _buildSettingTile(
              icon: Icons.star_outline,
              title: "Rate App",
              onTap: () {},
            ),
            _buildSettingTile(
              icon: Icons.share_outlined,
              title: "Share App",
              onTap: () {},
            ),

            const SizedBox(height: 24),

            // Logout
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/'),
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text(
                    "Log Out",
                    style: TextStyle(color: Colors.red),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: AppColors.textGrey,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.lightSurface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.textDark, size: 20),
      ),
      title: Text(title),
      subtitle: subtitle != null
          ? Text(subtitle, style: TextStyle(color: AppColors.textGrey))
          : null,
      trailing:
          trailing ??
          (onTap != null
              ? const Icon(Icons.chevron_right, color: AppColors.textGrey)
              : null),
      onTap: onTap,
    );
  }

  void _showCurrencyPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          const Text(
            "Select Currency",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 16),
          ...['INR', 'USD', 'EUR', 'GBP'].map(
            (c) => ListTile(
              leading: Icon(
                c == _currency
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
              ),
              title: Text(c),
              onTap: () {
                setState(() => _currency = c);
                Navigator.pop(context);
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          const Text(
            "Select Language",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 16),
          ...['English', 'Hindi', 'Tamil', 'Telugu', 'Kannada'].map(
            (l) => ListTile(
              leading: Icon(
                l == _language
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
              ),
              title: Text(l),
              onTap: () {
                setState(() => _language = l);
                Navigator.pop(context);
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
