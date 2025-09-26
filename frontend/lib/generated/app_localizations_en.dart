// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Anchiano';

  @override
  String get tasksTitle => 'Tasks';

  @override
  String get priority => 'Priority';

  @override
  String get status => 'Status';

  @override
  String get description => 'Description';

  @override
  String get due => 'Due';
}
