import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class LanguageProvider with ChangeNotifier {
  Locale _locale = const Locale('pt', '');
  String _fallbackFile = 'pt';

  Locale get locale => _locale;
  String get fallbackFile => _fallbackFile;

  Iterable<Locale> supportedLocales = const [
    Locale('pt', ''),
    Locale('en', ''),
  ];

  Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates ({required String fallbackFile, required Locale locale}) => [
    FlutterI18nDelegate(
      translationLoader: FileTranslationLoader(
        useCountryCode: false,
        fallbackFile: fallbackFile,
        forcedLocale: locale,
      ),
    ),
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  void setLocale(Locale newLocale) {
    _locale = newLocale;
    _fallbackFile = newLocale.languageCode;
    notifyListeners();
  }
}
