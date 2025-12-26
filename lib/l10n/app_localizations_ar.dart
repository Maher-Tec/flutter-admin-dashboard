// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'سناعتي أدمن';

  @override
  String get dashboard => 'لوحة التحكم';

  @override
  String get users => 'المستخدمين';

  @override
  String get analytics => 'التحليلات';

  @override
  String get settings => 'الإعدادات';

  @override
  String get welcomeBack => 'مرحباً بعودتك،';

  @override
  String get overview => 'نظرة عامة';

  @override
  String get totalUsers => 'إجمالي المستخدمين';

  @override
  String get activeSessions => 'الجلسات النشطة';

  @override
  String get totalRevenue => 'إجمالي الإيرادات';

  @override
  String get conversionRate => 'معدل التحويل';

  @override
  String get vsLastMonth => 'مقارنة بالشهر الماضي';

  @override
  String get recentActivity => 'النشاط الأخير';

  @override
  String get search => 'بحث...';

  @override
  String get notifications => 'التنبيهات';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get language => 'اللغة';

  @override
  String get english => 'الإنجليزية';

  @override
  String get french => 'الفرنسية';

  @override
  String get arabic => 'العربية';

  @override
  String get user => 'المستخدم';

  @override
  String get activity => 'النشاط';

  @override
  String get status => 'الحالة';

  @override
  String get date => 'التاريخ';

  @override
  String get goodMorning => 'صباح الخير';

  @override
  String get goodAfternoon => 'مساء الخير';

  @override
  String get goodEvening => 'مساء الخير';

  @override
  String get admin => 'المشرف';

  @override
  String welcomeAdmin(Object greeting, Object name) {
    return '$greeting، $name! 👋';
  }

  @override
  String get welcomeSubtitle => 'إليك ما يحدث في عملك اليوم.';

  @override
  String get weeklyRevenue => 'الإيرادات الأسبوعية';

  @override
  String get dailyActivity => 'النشاط اليومي';

  @override
  String get adminDashboard => 'لوحة تحكم المشرف';

  @override
  String get poweredBy => 'بدعم من';

  @override
  String get toggleSidebar => 'تبديل الشريط الجانبي';

  @override
  String get filter => 'تصفية';

  @override
  String showingResults(Object end, Object start, Object total) {
    return 'عرض $start-$end من أصل $total نتائج';
  }

  @override
  String minutesAgo(Object count) {
    return 'منذ $count دقيقة';
  }

  @override
  String hoursAgo(Object count) {
    return 'منذ $count ساعة';
  }

  @override
  String daysAgo(Object count) {
    return 'منذ $count يوم';
  }

  @override
  String get noNotifications => 'لا توجد تنبيهات جديدة';

  @override
  String get switchToLightMode => 'تبديل إلى الوضع الفاتح';

  @override
  String get switchToDarkMode => 'تبديل إلى الوضع الداكن';

  @override
  String get adminUser => 'مستخدم مسؤول';

  @override
  String get id => 'معرف';
}
