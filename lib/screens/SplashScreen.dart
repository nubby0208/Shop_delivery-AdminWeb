import 'package:flutter/material.dart';
import 'package:local_delivery_admin/utils/Constants.dart';
import 'package:local_delivery_admin/utils/Extensions/app_common.dart';

import '../main.dart';
import 'DashboardScreen.dart';
import 'LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  static String tag = '/SplashScreen';

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    Future.delayed(
      Duration(seconds: 2),
      () {
        if (appStore.isLoggedIn) {
          launchScreen(context, DashboardScreen(), isNewTask: true);
        } else {
          launchScreen(context, LoginScreen(), isNewTask: true);
        }
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(defaultRadius),
              child: Image.asset('assets/app_logo_primary.png',width: 100,height: 100,fit: BoxFit.cover),
            ),
            SizedBox(height: 16),
            Text(language.app_name, style: boldTextStyle(size: 20)),
          ],
        ),
      ),
    );
  }
}
