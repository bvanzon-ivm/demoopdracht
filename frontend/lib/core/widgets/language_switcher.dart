import 'package:flutter/material.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    String flag(Locale l) => l.languageCode == 'nl' ? '🇳🇱' : '🇬🇧';

    return PopupMenuButton<Locale>(
      icon: Text(flag(locale), style: const TextStyle(fontSize: 20)),
      onSelected: (l) {
        LocaleSettings.of(context).set(l);
      },
      itemBuilder: (_) => const [
        PopupMenuItem(value: Locale('nl'), child: Text('🇳🇱 Nederlands')),
        PopupMenuItem(value: Locale('en'), child: Text('🇬🇧 English')),
      ],
    );
  }
}

/// Eenvoudige locale-controller om op runtime te wisselen.
class LocaleSettings extends InheritedWidget {
  final ValueNotifier<Locale> _notifier;
  LocaleSettings({super.key, required Widget child, required Locale initial})
      : _notifier = ValueNotifier(initial),
        super(child: _LocaleHost(child: child));

  static LocaleSettings of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LocaleSettings>()!;

  void set(Locale l) => _notifier.value = l;
  Locale get current => _notifier.value;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}

class _LocaleHost extends StatefulWidget {
  final Widget child;
  const _LocaleHost({required this.child});
  @override
  State<_LocaleHost> createState() => _LocaleHostState();
}

class _LocaleHostState extends State<_LocaleHost> {
  @override
  Widget build(BuildContext context) {
    final settings = LocaleSettings.of(context);
    return ValueListenableBuilder<Locale>(
      valueListenable: settings._notifier,
      builder: (_, locale, __) => Localizations.override(
        context: context,
        locale: locale,
        child: widget.child,
      ),
    );
  }
}
