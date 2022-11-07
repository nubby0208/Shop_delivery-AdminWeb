import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:local_delivery_admin/components/ChangePasswordDialog.dart';
import 'package:local_delivery_admin/components/EditProfileDialog.dart';

import '../main.dart';
import '../models/models.dart';
import '../screens/DashboardScreen.dart';
import '../utils/Colors.dart';
import '../utils/Common.dart';
import '../utils/Constants.dart';
import '../utils/DataProvider.dart';
import '../utils/Extensions/LiveStream.dart';
import '../utils/Extensions/app_common.dart';
import '../utils/Extensions/on_hover.dart';
import 'LanguageListWidget.dart';
import 'NotificationDialog.dart';

class BodyCornerWidget extends StatefulWidget {
  static String tag = '/BodyCornerWidget2';
  final Widget? child;
  final bool? isDashboard;

  BodyCornerWidget({this.child, this.isDashboard = false});

  @override
  BodyCornerWidgetState createState() => BodyCornerWidgetState();
}

class BodyCornerWidgetState extends State<BodyCornerWidget> {
  List<MenuItemModel> menuList = getMenuItems();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
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

  getBodyWidth() {
    return MediaQuery.of(context).size.width - getMenuWidth();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 60,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Image.asset('assets/app_logo_white.png', height: 50, width: 50, fit: BoxFit.cover),
              SizedBox(width: 16),
              Text(language.app_name, style: boldTextStyle(color: Colors.white, size: 20)),
            ],
          ),
          actions: [
            PopupMenuButton(
              padding: EdgeInsets.zero,
              child: Observer(
                builder: (_) => SizedBox(
                  width: 35,
                  child: Stack(
                    children: [
                      Align(
                        alignment: AlignmentDirectional.center,
                        child: Icon(Icons.notifications),
                      ),
                      if (appStore.allUnreadCount != 0)
                        Positioned(
                          right: 2,
                          top: 8,
                          child: Container(
                            height: 18,
                            width: 18,
                            padding: EdgeInsets.all(4),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                            child: Observer(builder: (_) {
                              return Text('${appStore.allUnreadCount < 99 ? appStore.allUnreadCount : '99+'}', style: primaryTextStyle(size: 10, color: Colors.white));
                            }),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              itemBuilder: (_) => [
                PopupMenuItem(
                  padding: EdgeInsets.zero,
                  child: Container(
                    width: 500,
                    child: NotificationDialog(),
                  ),
                )
              ],
              tooltip: language.notification,
            ),
            SizedBox(width: 16),
            Tooltip(
              message: language.theme,
              child: FlutterSwitch(
                value: appStore.isDarkMode,
                width: 55,
                height: 30,
                toggleSize: 25,
                borderRadius: 30.0,
                padding: 4.0,
                activeIcon: ImageIcon(AssetImage('assets/icons/ic_moon.png'), color: Colors.white, size: 30),
                inactiveIcon: ImageIcon(AssetImage('assets/icons/ic_sun.png'), color: Colors.white, size: 30),
                activeColor: primaryColor,
                activeToggleColor: Colors.black,
                inactiveToggleColor: Colors.orangeAccent,
                inactiveColor: Colors.white,
                onToggle: (value) {
                  appStore.setDarkMode(value);
                  shared_pref.setInt(THEME_MODE_INDEX, value ? 1 : 0);
                  LiveStream().emit(streamDarkMode);
                },
              ),
            ),
            SizedBox(width: 16),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(defaultRadius)),
              child: LanguageListWidget(
                widgetType: WidgetType.DROPDOWN,
                onLanguageChange: (val) async {
                  appStore.setLanguage(val.languageCode ?? '-');
                  await shared_pref.setString(SELECTED_LANGUAGE_CODE, val.languageCode ?? '');
                  LiveStream().emit(streamLanguage);
                  setState(() {});
                },
              ),
            ),
            PopupMenuButton(
              padding: EdgeInsets.zero,
              child: Padding(
                padding: EdgeInsets.only(right: 16, top: 10, bottom: 10),
                child: Row(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.withOpacity(0.15)),
                        shape: BoxShape.circle,
                        image: DecorationImage(image: NetworkImage('${appStore.userProfile}'), fit: BoxFit.cover),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${shared_pref.getString(NAME) ?? ""}', style: boldTextStyle(color: Colors.white)),
                        SizedBox(height: 4),
                        Text(shared_pref.getString(USER_EMAIL) ?? "", style: secondaryTextStyle(size: 14, color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ),
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: [
                      Icon(Icons.person, color: appStore.isDarkMode ? Colors.white : Colors.grey),
                      SizedBox(width: 8),
                      Text(language.editProfile),
                    ],
                  ),
                  textStyle: primaryTextStyle(),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Row(
                    children: [
                      Icon(Icons.lock, color: appStore.isDarkMode ? Colors.white : Colors.grey),
                      SizedBox(width: 8),
                      Text(language.changePassword),
                    ],
                  ),
                  textStyle: primaryTextStyle(),
                ),
                PopupMenuItem(
                  value: 3,
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: appStore.isDarkMode ? Colors.white : Colors.grey),
                      SizedBox(width: 8),
                      Text(language.logout),
                    ],
                  ),
                  textStyle: primaryTextStyle(),
                ),
              ],
              onSelected: (value) {
                if (value == 1) {
                  showDialog(
                    context: context,
                    barrierDismissible: false, // false = user must tap button, true = tap outside dialog
                    builder: (BuildContext dialogContext) {
                      return EditProfileDialog();
                    },
                  );
                } else if (value == 2) {
                  showDialog(
                    context: context,
                    barrierDismissible: false, // false = user must tap button, true = tap outside dialog
                    builder: (BuildContext dialogContext) {
                      return ChangePasswordDialog();
                    },
                  );
                } else if (value == 3) {
                  logOutData(context: context);
                }
              },
              tooltip: language.profile,
            ),
          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                width: getMenuWidth(),
                child: Container(
                  color: appStore.isDarkMode ? scaffoldColorDark : primaryColor,
                  padding: EdgeInsets.only(top: 16, bottom: 16),
                  width: getMenuWidth(),
                  child: ListView(
                    children: menuList.map((item) {
                      return HoverWidget(builder: (context, isHovering) {
                        return GestureDetector(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 16),
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 16, top: 8, bottom: 8, right: appStore.selectedLanguage == 'ar' ? 16 : 0),
                            decoration: BoxDecoration(
                              color: appStore.selectedMenuIndex == item.index
                                  ? hoverColor
                                  : isHovering
                                      ? hoverColor
                                      : Colors.transparent,
                            ),
                            child: Row(
                              children: [
                                ImageIcon(AssetImage(item.imagePath!), size: 24, color: Colors.white),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    item.title!,
                                    maxLines: 1,
                                    style: appStore.selectedMenuIndex == item.index ? boldTextStyle(color: Colors.white) : primaryTextStyle(color: Colors.white, size: 15),
                                  ),
                                ),
                                appStore.selectedMenuIndex == item.index
                                    ? Card(
                                        margin: EdgeInsets.zero,
                                        color: Theme.of(context).cardColor,
                                        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                        child: SizedBox(width: 30, height: 30),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                          onTap: () {
                            appStore.selectedMenuIndex = item.index!;
                            if (!widget.isDashboard!) {
                              launchScreen(context, DashboardScreen(), isNewTask: true);
                            }
                          },
                        );
                      });
                    }).toList(),
                  ),
                ),
              ),
              Positioned(
                left: appStore.selectedLanguage == 'ar' ? 0 : getMenuWidth() - 15,
                right: appStore.selectedLanguage == 'ar' ? getMenuWidth() - 30 : 0,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  alignment: AlignmentDirectional.topStart,
                  width: getBodyWidth(),
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: appStore.selectedLanguage == 'ar'
                        ? BorderRadius.only(topRight: Radius.circular(defaultRadius))
                        : BorderRadius.only(
                            topLeft: Radius.circular(defaultRadius),
                          ),
                  ),
                  child: widget.child,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
