// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Sana3ti Admin';

  @override
  String get dashboard => 'Tableau de Bord';

  @override
  String get users => 'Utilisateurs';

  @override
  String get analytics => 'Analytiques';

  @override
  String get settings => 'Paramètres';

  @override
  String get welcomeBack => 'Bon retour,';

  @override
  String get overview => 'Aperçu';

  @override
  String get totalUsers => 'Total Utilisateurs';

  @override
  String get activeSessions => 'Sessions Actives';

  @override
  String get totalRevenue => 'Revenu Total';

  @override
  String get conversionRate => 'Taux de Conversion';

  @override
  String get vsLastMonth => 'vs mois dernier';

  @override
  String get recentActivity => 'Activité Récente';

  @override
  String get search => 'Rechercher...';

  @override
  String get notifications => 'Notifications';

  @override
  String get profile => 'Profil';

  @override
  String get logout => 'Déconnexion';

  @override
  String get language => 'Langue';

  @override
  String get english => 'Anglais';

  @override
  String get french => 'Français';

  @override
  String get arabic => 'Arabe';

  @override
  String get user => 'Utilisateur';

  @override
  String get activity => 'Activité';

  @override
  String get status => 'Statut';

  @override
  String get date => 'Date';

  @override
  String get goodMorning => 'Bon matin';

  @override
  String get goodAfternoon => 'Bon après-midi';

  @override
  String get goodEvening => 'Bonsoir';

  @override
  String get admin => 'Admin';

  @override
  String welcomeAdmin(Object greeting, Object name) {
    return '$greeting, $name! 👋';
  }

  @override
  String get welcomeSubtitle =>
      'Voici ce qui se passe dans votre entreprise aujourd\'hui.';

  @override
  String get weeklyRevenue => 'Revenu Hebdomadaire';

  @override
  String get dailyActivity => 'Activité Quotidienne';

  @override
  String get adminDashboard => 'Tableau de Bord Admin';

  @override
  String get poweredBy => 'Propulsé par';

  @override
  String get toggleSidebar => 'Basculer la barre latérale';

  @override
  String get filter => 'Filtrer';

  @override
  String showingResults(Object end, Object start, Object total) {
    return 'Affichage de $start-$end sur $total résultats';
  }

  @override
  String minutesAgo(Object count) {
    return 'Il y a ${count}m';
  }

  @override
  String hoursAgo(Object count) {
    return 'Il y a ${count}h';
  }

  @override
  String daysAgo(Object count) {
    return 'Il y a ${count}j';
  }

  @override
  String get noNotifications => 'Pas de nouvelles notifications';

  @override
  String get switchToLightMode => 'Passer en mode clair';

  @override
  String get switchToDarkMode => 'Passer en mode sombre';

  @override
  String get adminUser => 'Utilisateur Admin';

  @override
  String get id => 'ID';
}
