import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../main.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);

    return DropdownButton<Locale>(
      value: locale,
      icon: const Icon(Icons.language),
      underline: const SizedBox(),
      onChanged: (Locale? newLocale) {
        if (newLocale != null) {
          // via InheritedWidget of Provider in main.dart
          MyApp.setLocale(context, newLocale);
        }
      },
      items: const [
        DropdownMenuItem(
          value: Locale('en'),
          child: Text('English'),
        ),
        DropdownMenuItem(
          value: Locale('nl'),
          child: Text('Nederlands'),
        ),
      ],
    );
  }
}
