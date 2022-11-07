import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:local_delivery_admin/AppTheme.dart';
import 'package:local_delivery_admin/language/AppLocalizations.dart';
import 'package:local_delivery_admin/language/BaseLanguage.dart';
import 'package:local_delivery_admin/models/LanguageDataModel.dart';
import 'package:local_delivery_admin/screens/SplashScreen.dart';
import 'package:local_delivery_admin/store/AppStore.dart';
import 'package:local_delivery_admin/utils/Colors.dart';
import 'package:local_delivery_admin/utils/Common.dart';
import 'package:local_delivery_admin/utils/Constants.dart';
import 'package:local_delivery_admin/utils/DataProvider.dart';
import 'package:local_delivery_admin/utils/Extensions/StringExtensions.dart';
import 'package:shared_preferences/shared_preferences.dart';


AppStore appStore = AppStore();
late SharedPreferences shared_pref;
Color textPrimaryColorGlobal = textPrimaryColor;
Color textSecondaryColorGlobal = textSecondaryColor;
Color defaultLoaderBgColorGlobal = Colors.white;

late BaseLanguage language;
List<LanguageDataModel> localeLanguageList = [];
LanguageDataModel? selectedLanguageDataModel;

Future<void> initialize({
  double? defaultDialogBorderRadius,
  List<LanguageDataModel>? aLocaleLanguageList,
  String? defaultLanguage,
}) async {
  localeLanguageList = aLocaleLanguageList ?? [];
  selectedLanguageDataModel = getSelectedLanguageModel(defaultLanguage: default_Language);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  shared_pref = await SharedPreferences.getInstance();

  await initialize(aLocaleLanguageList: languageList());
  appStore.setLanguage(default_Language);

  int themeModeIndex = shared_pref.getInt(THEME_MODE_INDEX) ?? 0;
  appStore.setLoggedIn(shared_pref.getBool(IS_LOGGED_IN) ?? false, isInitializing: true);
  appStore.setUserProfile(shared_pref.getString(USER_PROFILE_PHOTO).validate(),isInitializing: true);

  if (themeModeIndex == ThemeModeLight) {
    appStore.setDarkMode(false);
  } else if (themeModeIndex == ThemeModeDark) {
    appStore.setDarkMode(true);
  }
  saveFcmTokenId();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return MaterialApp(
          builder: (context, child) {
            return ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.touch,
                },
              ),
              child: child!,
            );
          },
          debugShowCheckedModeBanner: false,
          title: language.app_name,

          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: appStore.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: SplashScreen(),
          supportedLocales: LanguageDataModel.languageLocales(),
          localizationsDelegates: [
            AppLocalizations(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) => locale,
          locale: Locale(appStore.selectedLanguage.validate(value: default_Language)));
    });
  }
}
