import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_delivery_admin/language/AppLocalizations.dart';
import 'package:local_delivery_admin/language/BaseLanguage.dart';
import 'package:local_delivery_admin/main.dart';
import 'package:local_delivery_admin/models/CountryListModel.dart';
import 'package:local_delivery_admin/models/LanguageDataModel.dart';
import 'package:local_delivery_admin/utils/Colors.dart';
import 'package:local_delivery_admin/utils/Constants.dart';
import 'package:local_delivery_admin/utils/Extensions/app_common.dart';
import 'package:mobx/mobx.dart';

part 'AppStore.g.dart';

class AppStore = _AppStore with _$AppStore;

abstract class _AppStore with Store {

  @observable
  bool isLoggedIn = false;

  @observable
  bool isLoading = false;

  @observable
  List<CountryData> countryList = ObservableList<CountryData>();

  @observable
  int allUnreadCount = 0;

  @observable
  bool isDarkMode = false;

  @observable
  AppBarTheme appBarTheme = AppBarTheme();

  @observable
  String selectedLanguage = "en";

  @observable
  int selectedMenuIndex = 0;

  @observable
  String userProfile = '';

  @observable
  String currencyCode = "INR";

  @observable
  String currencySymbol = "₹";

  @observable
  String currencyPosition = CURRENCY_POSITION_LEFT;

  @action
  Future<void> setLoggedIn(bool val, {bool isInitializing = false}) async {
    isLoggedIn = val;
    if (!isInitializing) await shared_pref.setBool(IS_LOGGED_IN, val);
  }

  @action
  Future<void> setLoading(bool value) async {
    isLoading = value;
  }

  @action
  void setAllUnreadCount(int val) {
    allUnreadCount = val;
  }

  @action
  void setSelectedMenuIndex(int val) {
    selectedMenuIndex = val;
  }

  @action
  Future<void> setUserProfile(String val, {bool isInitializing = false}) async {
    userProfile = val;
    if (!isInitializing) await shared_pref.setString(USER_PROFILE_PHOTO, val);
  }

  @action
  Future<void> setCurrencyCode(String val) async {
    currencyCode = val;
  }

  @action
  Future<void> setCurrencySymbol(String val) async {
    currencySymbol = val;
  }

  @action
  Future<void> setCurrencyPosition(String val) async {
    currencyPosition = val;
  }

  @action
  Future<void> setDarkMode(bool aIsDarkMode) async {
    isDarkMode = aIsDarkMode;

    if (isDarkMode) {
      textPrimaryColorGlobal = Colors.white;
      textSecondaryColorGlobal = textSecondaryColor;

      defaultLoaderBgColorGlobal = scaffoldSecondaryDark;
      //shadowColorGlobal = Colors.white12;

    } else {
      textPrimaryColorGlobal = textPrimaryColor;
      textSecondaryColorGlobal = textSecondaryColor;

      defaultLoaderBgColorGlobal = Colors.white;
    }
    appBarTheme = AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(statusBarIconBrightness: appStore.isDarkMode ? Brightness.dark : Brightness.light),
    );
  }

  @action
  Future<void> setLanguage(String aCode, {BuildContext? context}) async {
    selectedLanguageDataModel = getSelectedLanguageModel(defaultLanguage: defaultValues.defaultLanguage);
    selectedLanguage = getSelectedLanguageModel(defaultLanguage: defaultValues.defaultLanguage)!.languageCode!;

    //shared_pref.setString(SELECTED_LANGUAGE_CODE, aCode);

    if (context != null) language = BaseLanguage.of(context)!;
    language = await AppLocalizations().load(Locale(selectedLanguage));
  }

}