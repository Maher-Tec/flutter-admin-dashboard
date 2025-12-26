// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Sana3ti Admin';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get users => 'Users';

  @override
  String get analytics => 'Analytics';

  @override
  String get settings => 'Settings';

  @override
  String get welcomeBack => 'Welcome Back,';

  @override
  String get overview => 'Overview';

  @override
  String get totalUsers => 'Total Users';

  @override
  String get activeSessions => 'Active Sessions';

  @override
  String get totalRevenue => 'Total Revenue';

  @override
  String get conversionRate => 'Conversion Rate';

  @override
  String get vsLastMonth => 'vs last month';

  @override
  String get recentActivity => 'Recent Activity';

  @override
  String get search => 'Search...';

  @override
  String get notifications => 'Notifications';

  @override
  String get profile => 'Profile';

  @override
  String get logout => 'Logout';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get french => 'French';

  @override
  String get arabic => 'Arabic';

  @override
  String get user => 'User';

  @override
  String get activity => 'Activity';

  @override
  String get status => 'Status';

  @override
  String get date => 'Date';

  @override
  String get goodMorning => 'Good morning';

  @override
  String get goodAfternoon => 'Good afternoon';

  @override
  String get goodEvening => 'Good evening';

  @override
  String get admin => 'Admin';

  @override
  String welcomeAdmin(Object greeting, Object name) {
    return '$greeting, $name! 👋';
  }

  @override
  String get welcomeSubtitle =>
      'Here\'s what\'s happening with your business today.';

  @override
  String get weeklyRevenue => 'Weekly Revenue';

  @override
  String get dailyActivity => 'Daily Activity';

  @override
  String get adminDashboard => 'Admin Dashboard';

  @override
  String get poweredBy => 'Powered by';

  @override
  String get toggleSidebar => 'Toggle Sidebar';

  @override
  String get filter => 'Filter';

  @override
  String showingResults(Object end, Object start, Object total) {
    return 'Showing $start-$end of $total results';
  }

  @override
  String minutesAgo(Object count) {
    return '${count}m ago';
  }

  @override
  String hoursAgo(Object count) {
    return '${count}h ago';
  }

  @override
  String daysAgo(Object count) {
    return '${count}d ago';
  }

  @override
  String get noNotifications => 'No new notifications';

  @override
  String get switchToLightMode => 'Switch to light mode';

  @override
  String get switchToDarkMode => 'Switch to dark mode';

  @override
  String get adminUser => 'Admin User';

  @override
  String get id => 'ID';
}
