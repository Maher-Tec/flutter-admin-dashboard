import 'package:flutter/material.dart';

/// App-wide constants
class AppConstants {
  AppConstants._();

  // Sidebar dimensions
  static const double sidebarExpandedWidth = 260.0;
  static const double sidebarCollapsedWidth = 80.0;
  
  // Breakpoints
  static const double mobileBreakpoint = 650.0;
  static const double tabletBreakpoint = 1100.0;
  
  // Padding & Spacing
  static const double paddingXS = 4.0;
  static const double paddingSM = 8.0;
  static const double paddingMD = 16.0;
  static const double paddingLG = 24.0;
  static const double paddingXL = 32.0;
  
  // Border radius
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 24.0;
  
  // Animation durations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
}

/// Navigation items for the sidebar
enum NavItem {
  dashboard(
    icon: Icons.dashboard_rounded,
    label: 'Dashboard',
  ),
  users(
    icon: Icons.people_rounded,
    label: 'Users',
  ),
  orders(
    icon: Icons.shopping_bag_rounded,
    label: 'Orders',
  ),
  analytics(
    icon: Icons.analytics_rounded,
    label: 'Analytics',
  ),
  settings(
    icon: Icons.settings_rounded,
    label: 'Settings',
  );

  const NavItem({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;
}
