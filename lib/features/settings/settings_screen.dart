import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/providers/theme_provider.dart';

/// Settings screen
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppConstants.paddingLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          SizedBox(height: AppConstants.paddingLG),
          
          // Appearance Section
          _SettingsSection(
            title: 'Appearance',
            isDark: isDark,
            children: [
              _ThemeSetting(isDark: isDark),
            ],
          ),
          
          SizedBox(height: AppConstants.paddingMD),
          
          // Language Section
          _SettingsSection(
            title: 'Language & Region',
            isDark: isDark,
            children: [
              _LanguageSetting(isDark: isDark),
            ],
          ),
          
          SizedBox(height: AppConstants.paddingMD),
          
          // Profile Section
          _SettingsSection(
            title: 'Profile Settings',
            isDark: isDark,
            children: [
              _ProfileSetting(isDark: isDark),
            ],
          ),
          
          SizedBox(height: AppConstants.paddingMD),
          
          // About Section
          _SettingsSection(
            title: 'About',
            isDark: isDark,
            children: [
              _AboutSetting(isDark: isDark),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.title,
    required this.isDark,
    required this.children,
  });

  final String title;
  final bool isDark;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        border: Border.all(
          color: isDark
              ? AppColors.darkDivider.withValues(alpha: 0.5)
              : AppColors.lightDivider.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(AppConstants.paddingLG),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
          ),
          Divider(height: 1),
          ...children,
        ],
      ),
    );
  }
}

class _ThemeSetting extends StatelessWidget {
  const _ThemeSetting({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return ListTile(
      leading: Icon(isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded),
      title: Text('Theme'),
      subtitle: Text(isDark ? 'Dark' : 'Light'),
      trailing: Switch(
        value: isDark,
        onChanged: (_) => themeProvider.toggleTheme(),
        activeColor: AppColors.primary,
      ),
    );
  }
}

class _LanguageSetting extends StatelessWidget {
  const _LanguageSetting({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.language_rounded),
      title: Text('Language'),
      subtitle: Text('English (US)'),
      trailing: Icon(Icons.chevron_right_rounded),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Select Language'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _languageOption(context, 'English (US)', true),
                _languageOption(context, 'Spanish', false),
                _languageOption(context, 'French', false),
                _languageOption(context, 'German', false),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _languageOption(BuildContext context, String lang, bool selected) {
    return ListTile(
      title: Text(lang),
      trailing: selected ? Icon(Icons.check_rounded, color: AppColors.primary) : null,
      onTap: () => Navigator.pop(context),
    );
  }
}

class _ProfileSetting extends StatelessWidget {
  const _ProfileSetting({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.primary,
            child: Text('A', style: TextStyle(color: Colors.white)),
          ),
          title: Text('Admin User'),
          subtitle: Text('admin@example.com'),
          trailing: TextButton(child: Text('Edit'), onPressed: () {}),
        ),
        Divider(height: 1, indent: 16, endIndent: 16),
        ListTile(
          leading: Icon(Icons.lock_outline_rounded),
          title: Text('Change Password'),
          trailing: Icon(Icons.chevron_right_rounded),
          onTap: () {},
        ),
        Divider(height: 1, indent: 16, endIndent: 16),
        ListTile(
          leading: Icon(Icons.notifications_outlined),
          title: Text('Notifications'),
          subtitle: Text('Email & Push'),
          trailing: Icon(Icons.chevron_right_rounded),
          onTap: () {},
        ),
      ],
    );
  }
}

class _AboutSetting extends StatelessWidget {
  const _AboutSetting({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.info_outline_rounded),
          title: Text('Version'),
          subtitle: Text('1.0.0'),
        ),
        Divider(height: 1, indent: 16, endIndent: 16),
        ListTile(
          leading: Icon(Icons.description_outlined),
          title: Text('Terms of Service'),
          trailing: Icon(Icons.open_in_new_rounded, size: 18),
          onTap: () {},
        ),
        Divider(height: 1, indent: 16, endIndent: 16),
        ListTile(
          leading: Icon(Icons.privacy_tip_outlined),
          title: Text('Privacy Policy'),
          trailing: Icon(Icons.open_in_new_rounded, size: 18),
          onTap: () {},
        ),
      ],
    );
  }
}
