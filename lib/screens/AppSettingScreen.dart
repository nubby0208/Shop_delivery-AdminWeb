import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:local_delivery_admin/main.dart';
import 'package:local_delivery_admin/models/AppSettingModel.dart';
import 'package:local_delivery_admin/network/RestApis.dart';
import 'package:local_delivery_admin/utils/Colors.dart';
import 'package:local_delivery_admin/utils/Common.dart';
import 'package:local_delivery_admin/utils/Constants.dart';
import 'package:local_delivery_admin/utils/DataProvider.dart';
import 'package:local_delivery_admin/utils/Extensions/StringExtensions.dart';
import 'package:local_delivery_admin/utils/Extensions/app_common.dart';

import '../utils/Extensions/app_textfield.dart';

class AppSettingScreen extends StatefulWidget {
  @override
  AppSettingScreenState createState() => AppSettingScreenState();
}

class AppSettingScreenState extends State<AppSettingScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ScrollController notificationController = ScrollController();
  TextEditingController currencySymbolController = TextEditingController();

  Map<String, dynamic> notificationSettings = {};
  int? settingId;
  bool isAutoAssign = false;
  bool isOtpVerifyOnPickupDelivery = true;

  TextEditingController distanceController = TextEditingController();
  String? distanceUnitType;

  List<String> currencyPositionList = [CURRENCY_POSITION_LEFT, CURRENCY_POSITION_RIGHT];
  String selectedCurrencyPosition = CURRENCY_POSITION_LEFT;

  String? currencyCode;
  String? currencySymbol;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(init);
  }

  void init() async {
    appStore.setLoading(true);
    await getAppSetting().then((value) {
      notificationSettings = value.notification_settings!.toJson();
      isAutoAssign = value.autoAssign == 1;
      isOtpVerifyOnPickupDelivery = value.otpVerifyOnPickupDelivery == 1;
      distanceController.text = '${value.distance ?? ''}';
      distanceUnitType = value.distanceUnit;
      settingId = value.id!;
      currencySymbolController.text = value.currency.validate(value: currencySymbolDefault);
      currencyCode = value.currencyCode;
      currencySymbol = value.currency;
      selectedCurrencyPosition = value.currencyPosition ?? CURRENCY_POSITION_LEFT;
      appStore.setLoading(false);
      setState(() {});
    }).catchError((error) {
      notificationSettings = getNotificationSetting();
      log("$error");
      setState(() {});
      appStore.setLoading(false);
    });
  }

  Future<void> saveAppSetting() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (distanceUnitType == null && isAutoAssign) return toast(language.please_select_distance_unit);
      appStore.setLoading(true);
      Map req = isAutoAssign
          ? {
              "id": settingId != null ? settingId : "",
              "notification_settings": NotificationSettings.fromJson(notificationSettings).toJson(),
              "auto_assign": isAutoAssign ? 1 : 0,
              "distance_unit": distanceUnitType,
              "distance": distanceController.text,
              "otp_verify_on_pickup_delivery": isOtpVerifyOnPickupDelivery ? 1 : 0,
              "currency": currencySymbol ?? currencySymbolDefault,
              "currency_code": currencyCode ?? currencyCodeDefault,
              "currency_position": selectedCurrencyPosition,
            }
          : {
              "id": settingId != null ? settingId : "",
              "auto_assign": isAutoAssign ? 1 : 0,
              "otp_verify_on_pickup_delivery": isOtpVerifyOnPickupDelivery ? 1 : 0,
              "notification_settings": NotificationSettings.fromJson(notificationSettings).toJson(),
              "currency": currencySymbol ?? currencySymbolDefault,
              "currency_code": currencyCode ?? currencyCodeDefault,
              "currency_position": selectedCurrencyPosition,
            };
      await setNotification(req).then((value) {
        appStore.setLoading(false);
        settingId = value.data!.id;
        appStore.setCurrencyCode(currencyCode ?? currencyCodeDefault);
        appStore.setCurrencySymbol(currencySymbol ?? currencySymbolDefault);
        appStore.setCurrencyPosition(selectedCurrencyPosition);
        toast(value.message);
      }).catchError((error) {
        appStore.setLoading(false);
        log(error);
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              controller: notificationController,
              padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 50),
              child: notificationSettings.isNotEmpty
                  ? Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(language.appSetting, style: boldTextStyle(size: 22, color: primaryColor)),
                              GestureDetector(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(defaultRadius)),
                                  child: Text(language.save, style: boldTextStyle(color: Colors.white)),
                                ),
                                onTap: () {
                                  if (shared_pref.getString(USER_TYPE) == DEMO_ADMIN) {
                                    toast(language.demo_admin_msg);
                                  } else {
                                    saveAppSetting();
                                  }
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(color: appStore.isDarkMode ? scaffoldColorDark : Colors.white, borderRadius: BorderRadius.circular(defaultRadius), boxShadow: commonBoxShadow()),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(language.notification_setting, style: boldTextStyle()),
                                      SizedBox(height: 16),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width,
                                        child: DataTable(
                                          headingTextStyle: boldTextStyle(size: 14),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(defaultRadius),
                                          ),
                                          dataTextStyle: primaryTextStyle(),
                                          headingRowColor: MaterialStateColor.resolveWith((states) => primaryColor.withOpacity(0.1)),
                                          showCheckboxColumn: false,
                                          dataRowHeight: 45,
                                          headingRowHeight: 45,
                                          horizontalMargin: 16,
                                          columns: [
                                            DataColumn(label: Text(language.type)),
                                            DataColumn(label: Text(language.one_single), numeric: true),
                                            DataColumn(label: Text('${language.firebase} ${language.for_admin}'), numeric: true),
                                          ],
                                          rows: notificationSettings.entries.map((e) {
                                            return DataRow(
                                              cells: [
                                                DataCell(Text(orderSettingStatus(e.key) ?? '', style: primaryTextStyle())),
                                                DataCell(
                                                  Checkbox(
                                                    value: e.value["IS_ONESIGNAL_NOTIFICATION"] == "1",
                                                    onChanged: (val) {
                                                      Notifications notify = Notifications.fromJson(notificationSettings[e.key]);
                                                      if (val ?? false) {
                                                        notify.isOnesignalNotification = "1";
                                                      } else {
                                                        notify.isOnesignalNotification = "0";
                                                      }
                                                      notificationSettings[e.key] = notify.toJson();
                                                      setState(() {});
                                                    },
                                                  ),
                                                ),
                                                DataCell(
                                                  Checkbox(
                                                    value: e.value["IS_FIREBASE_NOTIFICATION"] == "1",
                                                    onChanged: (val) {
                                                      Notifications notify = Notifications.fromJson(notificationSettings[e.key]);
                                                      if (val ?? false) {
                                                        notify.isFirebaseNotification = "1";
                                                      } else {
                                                        notify.isFirebaseNotification = "0";
                                                      }
                                                      notificationSettings[e.key] = notify.toJson();
                                                      setState(() {});
                                                    },
                                                  ),
                                                ),
                                              ],
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(color: appStore.isDarkMode ? scaffoldColorDark : Colors.white, borderRadius: BorderRadius.circular(defaultRadius), boxShadow: commonBoxShadow()),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SwitchListTile(
                                            value: isAutoAssign,
                                            onChanged: (value) {
                                              isAutoAssign = value;
                                              setState(() {});
                                            },
                                            title: Text(language.order_auto_assign, style: primaryTextStyle()),
                                            controlAffinity: ListTileControlAffinity.trailing,
                                            inactiveTrackColor: appStore.isDarkMode ? Colors.white12 : Colors.black12,
                                          ),
                                          if (isAutoAssign)
                                            Padding(
                                              padding: EdgeInsets.all(16),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(language.distance, style: primaryTextStyle()),
                                                  SizedBox(height: 8),
                                                  AppTextField(
                                                    controller: distanceController,
                                                    textFieldType: TextFieldType.OTHER,
                                                    decoration: commonInputDecoration(),
                                                    textInputAction: TextInputAction.next,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter.allow(RegExp('[0-9 .]')),
                                                    ],
                                                    validator: (s) {
                                                      if (s!.trim().isEmpty) return language.field_required_msg;
                                                      return null;
                                                    },
                                                  ),
                                                  SizedBox(height: 16),
                                                  Text(language.distance_unit, style: primaryTextStyle()),
                                                  SizedBox(height: 8),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: RadioListTile<String>(
                                                          value: DISTANCE_UNIT_KM,
                                                          title: Text(DISTANCE_UNIT_KM, style: primaryTextStyle()),
                                                          groupValue: distanceUnitType,
                                                          onChanged: (value) {
                                                            distanceUnitType = value;
                                                            setState(() {});
                                                          },
                                                        ),
                                                      ),
                                                      SizedBox(width: 16),
                                                      Expanded(
                                                        child: RadioListTile<String>(
                                                          value: DISTANCE_UNIT_MILE,
                                                          title: Text(DISTANCE_UNIT_MILE, style: primaryTextStyle()),
                                                          groupValue: distanceUnitType,
                                                          onChanged: (value) {
                                                            distanceUnitType = value;
                                                            setState(() {});
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          SwitchListTile(
                                            value: isOtpVerifyOnPickupDelivery,
                                            onChanged: (value) {
                                              isOtpVerifyOnPickupDelivery = value;
                                              setState(() {});
                                            },
                                            title: Text(language.otpVerificationOnPickupDelivery, style: primaryTextStyle()),
                                            controlAffinity: ListTileControlAffinity.trailing,
                                            inactiveTrackColor: appStore.isDarkMode ? Colors.white12 : Colors.black12,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Container(
                                      decoration: BoxDecoration(color: appStore.isDarkMode ? scaffoldColorDark : Colors.white, borderRadius: BorderRadius.circular(defaultRadius), boxShadow: commonBoxShadow()),
                                      padding: EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(language.currencySetting, style: boldTextStyle()),
                                          SizedBox(height: 16),
                                          Text(language.currencyPosition, style: primaryTextStyle()),
                                          SizedBox(height: 8),
                                          DropdownButtonFormField(
                                            decoration: commonInputDecoration(),
                                            value: selectedCurrencyPosition,
                                            dropdownColor: Theme.of(context).cardColor,
                                            items: currencyPositionList.map<DropdownMenuItem<String>>((item) {
                                              return DropdownMenuItem(
                                                value: item,
                                                child: Text('${item[0].toUpperCase()}${item.substring(1)}',style: primaryTextStyle()),
                                              );
                                            }).toList(),
                                            onChanged: (String? value) {
                                              selectedCurrencyPosition = value!;
                                              setState(() {});
                                            },
                                          ),
                                          SizedBox(height: 16),
                                          Text(language.currencySymbol, style: primaryTextStyle()),
                                          SizedBox(height: 8),
                                          AppTextField(
                                            controller: currencySymbolController,
                                            readOnly: true,
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                              filled: true,
                                              fillColor: Colors.grey.withOpacity(0.15),
                                              counterText: '',
                                              suffixIcon: GestureDetector(
                                                  child: Padding(
                                                    padding: EdgeInsets.all(10),
                                                    child: MouseRegion(cursor: SystemMouseCursors.click, child: Text(language.pick, style: primaryTextStyle(color: primaryColor))),
                                                  ),
                                                  onTap: () {
                                                    showCurrencyPicker(
                                                      theme: CurrencyPickerThemeData(
                                                        bottomSheetHeight: MediaQuery.of(context).size.height * 0.8,
                                                        backgroundColor:Theme.of(context).cardColor,
                                                        titleTextStyle: primaryTextStyle(size: 17),
                                                        subtitleTextStyle: primaryTextStyle(size: 15),
                                                      ),
                                                      context: context,
                                                      showFlag: true,
                                                      showSearchField: true,
                                                      showCurrencyName: true,
                                                      showCurrencyCode: true,
                                                      onSelect: (Currency currency) {
                                                        currencySymbolController.text = currency.symbol;
                                                        currencyCode = currency.code;
                                                        currencySymbol = currency.symbol;
                                                        setState(() {});
                                                      },
                                                    );
                                                  }),
                                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.none), borderRadius: BorderRadius.circular(defaultRadius)),
                                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryColor), borderRadius: BorderRadius.circular(defaultRadius)),
                                              errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red), borderRadius: BorderRadius.circular(defaultRadius)),
                                              focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red), borderRadius: BorderRadius.circular(defaultRadius)),
                                            ),
                                            textFieldType: TextFieldType.OTHER,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 80),
                        ],
                      ),
                    )
                  : SizedBox(),
            ),
            appStore.isLoading
                ? loaderWidget()
                : notificationSettings.isEmpty
                    ? emptyWidget()
                    : SizedBox()
          ],
        );
      },
    );
  }
}
