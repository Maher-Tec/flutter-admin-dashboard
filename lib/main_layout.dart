import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:admin_dash/l10n/app_localizations.dart';
import 'core/constants/constants.dart';
import 'core/responsive/responsive.dart';
import 'core/providers/navigation_provider.dart';
import 'widgets/sidebar.dart';
import 'widgets/dashboard_app_bar.dart';
import 'core/providers/language_provider.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/users/users_screen.dart';
import 'features/orders/orders_screen.dart';
import 'features/analytics/analytics_screen.dart';
import 'features/settings/settings_screen.dart';

/// Main layout shell with responsive sidebar/drawer
class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<NavigationProvider>();
    final languageProvider = context.watch<LanguageProvider>();
    final isDesktop = context.isDesktop;
    final isRTL = languageProvider.isRTL;

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: isDesktop ? null : _MobileDrawer(),
        body: Row(
          children: [
            // Sidebar (desktop only)
            if (isDesktop) AppSidebar(),
            
            // Main Content
            Expanded(
              child: Column(
                children: [
                  // App Bar
                  DashboardAppBar(
                    onMenuPressed: isDesktop
                        ? null
                        : () => _scaffoldKey.currentState?.openDrawer(),
                  ),
                  
                  // Content Area
                  Expanded(
                    child: _getPage(navProvider.currentItem),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getPage(NavItem item) {
    switch (item) {
      case NavItem.dashboard:
        return DashboardScreen();
      case NavItem.users:
        return UsersScreen();
      case NavItem.orders:
        return OrdersScreen();
      case NavItem.analytics:
        return AnalyticsScreen();
      case NavItem.settings:
        return SettingsScreen();
    }
  }
}

/// Mobile drawer wrapper
class _MobileDrawer extends StatelessWidget {
  const _MobileDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: _MobileDrawerContent(),
    );
  }
}

class _MobileDrawerContent extends StatelessWidget {
  const _MobileDrawerContent();

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<NavigationProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Column(
        children: [
          // Logo Header with AmoMaherTec logo
          Container(
            height: 72,
            padding: EdgeInsets.symmetric(horizontal: AppConstants.paddingMD),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppConstants.radiusSM),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppConstants.radiusSM),
                    child: Image.asset(
                      'assets/logo_without_bg.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: AppConstants.paddingSM),
                Text(
                  AppLocalizations.of(context)!.adminDashboard,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1),
          
          // Navigation Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(AppConstants.paddingSM),
              children: NavItem.values.map((item) {
                final isActive = navProvider.currentItem == item;
                return ListTile(
                  leading: Icon(
                    item.icon,
                    color: isActive
                        ? Theme.of(context).colorScheme.primary
                        : (isDark ? Colors.white70 : Colors.black54),
                  ),
                  title: Text(
                    item.label,
                    style: TextStyle(
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      color: isActive
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                  ),
                  selected: isActive,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusSM),
                  ),
                  onTap: () {
                    navProvider.navigateTo(item);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
          
          // Powered by AmoMaherTec footer
          Divider(height: 1),
          Padding(
            padding: EdgeInsets.all(AppConstants.paddingMD),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.asset(
                          'assets/logo_without_bg.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${AppLocalizations.of(context)!.poweredBy} AmoMaherTec',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '© ${DateTime.now().year} AmoMaherTec',
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark ? Colors.white38 : Colors.black38,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
