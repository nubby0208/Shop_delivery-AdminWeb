import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:local_delivery_admin/components/BodyCornerWidget.dart';
import 'package:local_delivery_admin/models/models.dart';
import 'package:local_delivery_admin/utils/Colors.dart';
import 'package:local_delivery_admin/utils/Constants.dart';
import 'package:local_delivery_admin/utils/DataProvider.dart';
import 'package:local_delivery_admin/utils/Extensions/LiveStream.dart';
import 'package:local_delivery_admin/utils/Extensions/StringExtensions.dart';
import 'package:local_delivery_admin/utils/Extensions/app_common.dart';

import '../main.dart';
import '../network/RestApis.dart';

class DashboardScreen extends StatefulWidget {
  static String tag = '/DashboardScreen';

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  List<MenuItemModel> menuList = getMenuItems();
  bool isHovering = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await getAppSetting().then((value) {
      appStore.setCurrencyCode(value.currencyCode ?? currencyCodeDefault);
      appStore.setCurrencySymbol(value.currency ?? currencySymbolDefault);
      appStore.setCurrencyPosition(value.currencyPosition ?? CURRENCY_POSITION_LEFT);
    }).catchError((error) {
      log(error.toString());
    });
    firebaseOnMessage();
    LiveStream().on(streamLanguage, (p0) {
      menuList.clear();
      menuList = getMenuItems();
      setState(() {});
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void firebaseOnMessage() {
    FirebaseMessaging.onMessage.listen((event) async {
      ElegantNotification.info(
        title: Text(event.notification!.title.validate(), style: boldTextStyle(color: primaryColor, size: 18)),
        description: Text(event.notification!.body.validate(), style: primaryTextStyle(color: Colors.black, size: 16)),
        notificationPosition: NotificationPosition.top,
        dismissible: true,
        animation: AnimationType.fromTop,
        showProgressIndicator: false,
        width: 400,
        height: 100,
        toastDuration: Duration(seconds: 10),
        iconSize: 0,
      ).show(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return BodyCornerWidget(
        isDashboard: true,
        child: menuList[appStore.selectedMenuIndex].widget,
      );
    });
  }
}
