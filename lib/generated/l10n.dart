// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class LyticsStrings {
  LyticsStrings();

  static LyticsStrings? _current;

  static LyticsStrings get current {
    assert(_current != null,
        'No instance of LyticsStrings was loaded. Try to initialize the LyticsStrings delegate before accessing LyticsStrings.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<LyticsStrings> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = LyticsStrings();
      LyticsStrings._current = instance;

      return instance;
    });
  }

  static LyticsStrings of(BuildContext context) {
    final instance = LyticsStrings.maybeOf(context);
    assert(instance != null,
        'No instance of LyticsStrings present in the widget tree. Did you add LyticsStrings.delegate in localizationsDelegates?');
    return instance!;
  }

  static LyticsStrings? maybeOf(BuildContext context) {
    return Localizations.of<LyticsStrings>(context, LyticsStrings);
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `YES`
  String get yes_answer {
    return Intl.message(
      'YES',
      name: 'yes_answer',
      desc: '',
      args: [],
    );
  }

  /// `NO`
  String get no_answer {
    return Intl.message(
      'NO',
      name: 'no_answer',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<LyticsStrings> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<LyticsStrings> load(Locale locale) => LyticsStrings.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
