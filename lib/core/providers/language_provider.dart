import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('en');

  Locale get currentLocale => _currentLocale;

  void setLocale(Locale locale) {
    if (!['en', 'fr', 'ar'].contains(locale.languageCode)) return;
    _currentLocale = locale;
    notifyListeners();
  }

  bool get isRTL => _currentLocale.languageCode == 'ar';
}
