// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AppStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AppStore on _AppStore, Store {
  late final _$isLoggedInAtom =
      Atom(name: '_AppStore.isLoggedIn', context: context);

  @override
  bool get isLoggedIn {
    _$isLoggedInAtom.reportRead();
    return super.isLoggedIn;
  }

  @override
  set isLoggedIn(bool value) {
    _$isLoggedInAtom.reportWrite(value, super.isLoggedIn, () {
      super.isLoggedIn = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_AppStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$countryListAtom =
      Atom(name: '_AppStore.countryList', context: context);

  @override
  List<CountryData> get countryList {
    _$countryListAtom.reportRead();
    return super.countryList;
  }

  @override
  set countryList(List<CountryData> value) {
    _$countryListAtom.reportWrite(value, super.countryList, () {
      super.countryList = value;
    });
  }

  late final _$allUnreadCountAtom =
      Atom(name: '_AppStore.allUnreadCount', context: context);

  @override
  int get allUnreadCount {
    _$allUnreadCountAtom.reportRead();
    return super.allUnreadCount;
  }

  @override
  set allUnreadCount(int value) {
    _$allUnreadCountAtom.reportWrite(value, super.allUnreadCount, () {
      super.allUnreadCount = value;
    });
  }

  late final _$isDarkModeAtom =
      Atom(name: '_AppStore.isDarkMode', context: context);

  @override
  bool get isDarkMode {
    _$isDarkModeAtom.reportRead();
    return super.isDarkMode;
  }

  @override
  set isDarkMode(bool value) {
    _$isDarkModeAtom.reportWrite(value, super.isDarkMode, () {
      super.isDarkMode = value;
    });
  }

  late final _$appBarThemeAtom =
      Atom(name: '_AppStore.appBarTheme', context: context);

  @override
  AppBarTheme get appBarTheme {
    _$appBarThemeAtom.reportRead();
    return super.appBarTheme;
  }

  @override
  set appBarTheme(AppBarTheme value) {
    _$appBarThemeAtom.reportWrite(value, super.appBarTheme, () {
      super.appBarTheme = value;
    });
  }

  late final _$selectedLanguageAtom =
      Atom(name: '_AppStore.selectedLanguage', context: context);

  @override
  String get selectedLanguage {
    _$selectedLanguageAtom.reportRead();
    return super.selectedLanguage;
  }

  @override
  set selectedLanguage(String value) {
    _$selectedLanguageAtom.reportWrite(value, super.selectedLanguage, () {
      super.selectedLanguage = value;
    });
  }

  late final _$selectedMenuIndexAtom =
      Atom(name: '_AppStore.selectedMenuIndex', context: context);

  @override
  int get selectedMenuIndex {
    _$selectedMenuIndexAtom.reportRead();
    return super.selectedMenuIndex;
  }

  @override
  set selectedMenuIndex(int value) {
    _$selectedMenuIndexAtom.reportWrite(value, super.selectedMenuIndex, () {
      super.selectedMenuIndex = value;
    });
  }

  late final _$userProfileAtom =
      Atom(name: '_AppStore.userProfile', context: context);

  @override
  String get userProfile {
    _$userProfileAtom.reportRead();
    return super.userProfile;
  }

  @override
  set userProfile(String value) {
    _$userProfileAtom.reportWrite(value, super.userProfile, () {
      super.userProfile = value;
    });
  }

  late final _$currencyCodeAtom =
      Atom(name: '_AppStore.currencyCode', context: context);

  @override
  String get currencyCode {
    _$currencyCodeAtom.reportRead();
    return super.currencyCode;
  }

  @override
  set currencyCode(String value) {
    _$currencyCodeAtom.reportWrite(value, super.currencyCode, () {
      super.currencyCode = value;
    });
  }

  late final _$currencySymbolAtom =
      Atom(name: '_AppStore.currencySymbol', context: context);

  @override
  String get currencySymbol {
    _$currencySymbolAtom.reportRead();
    return super.currencySymbol;
  }

  @override
  set currencySymbol(String value) {
    _$currencySymbolAtom.reportWrite(value, super.currencySymbol, () {
      super.currencySymbol = value;
    });
  }

  late final _$currencyPositionAtom =
      Atom(name: '_AppStore.currencyPosition', context: context);

  @override
  String get currencyPosition {
    _$currencyPositionAtom.reportRead();
    return super.currencyPosition;
  }

  @override
  set currencyPosition(String value) {
    _$currencyPositionAtom.reportWrite(value, super.currencyPosition, () {
      super.currencyPosition = value;
    });
  }

  late final _$setLoggedInAsyncAction =
      AsyncAction('_AppStore.setLoggedIn', context: context);

  @override
  Future<void> setLoggedIn(bool val, {bool isInitializing = false}) {
    return _$setLoggedInAsyncAction
        .run(() => super.setLoggedIn(val, isInitializing: isInitializing));
  }

  late final _$setLoadingAsyncAction =
      AsyncAction('_AppStore.setLoading', context: context);

  @override
  Future<void> setLoading(bool value) {
    return _$setLoadingAsyncAction.run(() => super.setLoading(value));
  }

  late final _$setUserProfileAsyncAction =
      AsyncAction('_AppStore.setUserProfile', context: context);

  @override
  Future<void> setUserProfile(String val, {bool isInitializing = false}) {
    return _$setUserProfileAsyncAction
        .run(() => super.setUserProfile(val, isInitializing: isInitializing));
  }

  late final _$setCurrencyCodeAsyncAction =
      AsyncAction('_AppStore.setCurrencyCode', context: context);

  @override
  Future<void> setCurrencyCode(String val) {
    return _$setCurrencyCodeAsyncAction.run(() => super.setCurrencyCode(val));
  }

  late final _$setCurrencySymbolAsyncAction =
      AsyncAction('_AppStore.setCurrencySymbol', context: context);

  @override
  Future<void> setCurrencySymbol(String val) {
    return _$setCurrencySymbolAsyncAction
        .run(() => super.setCurrencySymbol(val));
  }

  late final _$setCurrencyPositionAsyncAction =
      AsyncAction('_AppStore.setCurrencyPosition', context: context);

  @override
  Future<void> setCurrencyPosition(String val) {
    return _$setCurrencyPositionAsyncAction
        .run(() => super.setCurrencyPosition(val));
  }

  late final _$setDarkModeAsyncAction =
      AsyncAction('_AppStore.setDarkMode', context: context);

  @override
  Future<void> setDarkMode(bool aIsDarkMode) {
    return _$setDarkModeAsyncAction.run(() => super.setDarkMode(aIsDarkMode));
  }

  late final _$setLanguageAsyncAction =
      AsyncAction('_AppStore.setLanguage', context: context);

  @override
  Future<void> setLanguage(String aCode, {BuildContext? context}) {
    return _$setLanguageAsyncAction
        .run(() => super.setLanguage(aCode, context: context));
  }

  late final _$_AppStoreActionController =
      ActionController(name: '_AppStore', context: context);

  @override
  void setAllUnreadCount(int val) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.setAllUnreadCount');
    try {
      return super.setAllUnreadCount(val);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedMenuIndex(int val) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.setSelectedMenuIndex');
    try {
      return super.setSelectedMenuIndex(val);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoggedIn: ${isLoggedIn},
isLoading: ${isLoading},
countryList: ${countryList},
allUnreadCount: ${allUnreadCount},
isDarkMode: ${isDarkMode},
appBarTheme: ${appBarTheme},
selectedLanguage: ${selectedLanguage},
selectedMenuIndex: ${selectedMenuIndex},
userProfile: ${userProfile},
currencyCode: ${currencyCode},
currencySymbol: ${currencySymbol},
currencyPosition: ${currencyPosition}
    ''';
  }
}
