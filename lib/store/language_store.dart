import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:signals/signals_flutter.dart';

import '../wj_utils.dart';

extension LanguageString on String {
  Map<String, String> get _map =>
      LanguageStore.to._languageMap[LanguageStore.to.locale.value] ?? {};
  String get tr => _map[this] ?? this;
  String trArgs([List<String> args = const []]) {
    var key = tr;
    if (args.isNotEmpty) {
      for (final arg in args) {
        key = key.replaceFirst(RegExp(r'%s'), arg.toString());
      }
    }
    return key;
  }
}

class LanguageStore {
  LanguageStore._();
  static final LanguageStore _instance = LanguageStore._();
  static LanguageStore get instance => _instance;
  static LanguageStore get to => _instance;

  late Map<Locale, Map<String, String>> _languageMap;
  late List<Locale> supportedLocales;
  late Map<Locale, String> supportedLanguageNames;
  static void init(Map<Locale, Map<String, String>> languageMap) =>
      _instance._internal(languageMap);

  void _internal(Map<Locale, Map<String, String>> languageMap) {
    _languageMap = {
      const Locale('zh', 'CN'): {'language.name': '简体中文'},
      const Locale('en', 'US'): {'language.name': 'English'},
      const Locale('ja', 'JP'): {'language.name': '日本語'},
      const Locale('ko', 'KR'): {'language.name': '한국어'},
    };
    addLanguageMap(AboutViewLanguage.languageMap);
    addLanguageMap(SettingViewLanguage.languageMap);
    addLanguageMap(languageMap);
    debugPrint('language_store.dart~_internal: ');
    var baseLanguage = findBaseLanguage();
    var index = supportedLocales.indexWhere((e) => e == baseLanguage);
    if (index == -1) index = 0;
    _languageIndex.value = GlobalUtil.pref.getInt('_languageIndex') ?? index;
  }

  Locale findBaseLanguage() {
    final platformLocales = PlatformDispatcher.instance.locales;
    debugPrint('language_store.dart~platformLocales: $platformLocales');
    for (var l in supportedLocales) {
      for (var pl in platformLocales) {
        if (pl.languageCode == l.languageCode) return l;
      }
    }
    return supportedLocales.first;
  }

  void addLanguageMap(Map<Locale, Map<String, String>> languageMap) {
    languageMap.forEach((key, val) {
      if (_languageMap.containsKey(key)) {
        _languageMap[key]!.addAll(val);
      } else {
        _languageMap[key] = Map.of(val);
      }
    });
    supportedLocales = _languageMap.keys.toList();
    supportedLanguageNames = supportedLocales.asMap().map(
      (index, locale) => MapEntry(
        locale,
        _languageMap[locale]!['language.name'] ?? locale.languageCode,
      ),
    );
  }

  final List<LocalizationsDelegate> localizationsDelegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];
  final _languageIndex = signal(0);
  late final locale = computed(() => supportedLocales[_languageIndex.value]);
  late final isChinese = computed(
    () => supportedLocales[_languageIndex.value].languageCode == 'zh',
  );

  void saveLanguageIndex(int index) {
    if (index < 0) return;
    if (index >= supportedLocales.length) return;
    _languageIndex.value = index;
    GlobalUtil.pref.setInt('_languageIndex', _languageIndex.value);
  }

  void toggleLanguage() {
    saveLanguageIndex(_languageIndex.value == 0 ? 1 : 0);
  }

  void resetLanguage() {
    var baseLanguage = findBaseLanguage();
    var index = supportedLocales.indexWhere((e) => e == baseLanguage);
    if (index == -1) index = 0;
    saveLanguageIndex(index);
  }
}
