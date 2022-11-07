import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:local_delivery_admin/main.dart';
import 'package:local_delivery_admin/network/RestApis.dart';
import 'package:local_delivery_admin/utils/Colors.dart';
import 'package:local_delivery_admin/utils/Extensions/ResponsiveWidget.dart';
import 'package:local_delivery_admin/utils/Extensions/StringExtensions.dart';
import 'package:lottie/lottie.dart';

import 'Constants.dart';
import 'Extensions/app_common.dart';

getMenuWidth() {
  //return isMenuExpanded ? 240 : 80;
  return 270;
}

getBodyWidth(BuildContext context) {
  return MediaQuery.of(context).size.width - getMenuWidth();
}

InputDecoration commonInputDecoration({String? hintText, IconData? suffixIcon, Function()? suffixOnTap,Widget? prefixIcon}) {
  return InputDecoration(
    prefixIcon: prefixIcon,
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    filled: true,
    hintText: hintText != null ? hintText : '',
    hintStyle: secondaryTextStyle(),
    fillColor: Colors.grey.withOpacity(0.15),
    counterText: '',
    suffixIcon: suffixIcon != null ? GestureDetector(child: Icon(suffixIcon, color: Colors.grey, size: 22), onTap: suffixOnTap) : null,
    enabledBorder: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.none), borderRadius: BorderRadius.circular(defaultRadius)),
    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryColor), borderRadius: BorderRadius.circular(defaultRadius)),
    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red), borderRadius: BorderRadius.circular(defaultRadius)),
    focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red), borderRadius: BorderRadius.circular(defaultRadius)),
  );
}

Widget commonButton(String title, Function() onTap, {double? width}) {
  return SizedBox(
    width: width,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultRadius)),
        elevation: 0,
        padding: EdgeInsets.symmetric(vertical: 20),
        primary: primaryColor,
      ),
      child: Text(title, style: boldTextStyle(color: Colors.white)),
      onPressed: onTap,
    ),
  );
}

List<BoxShadow> commonBoxShadow() {
  return [BoxShadow(color: Colors.black12, blurRadius: 10.0, spreadRadius: 0)];
}

Widget actionIcon(String title, Color color) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(defaultSmallRadius),
    ),
    child: Text(title, style: primaryTextStyle(size: 12, color: Colors.white)),
  );
}

Widget OutlineActionIcon(IconData icon, Color color, String message, Function() onTap) {
  return GestureDetector(
    child: Tooltip(
      message: message,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          height: 25,
          width: 25,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(defaultSmallRadius),
            border: Border.all(color: color),
          ),
          child: Icon(icon, color: color, size: 14),
        ),
      ),
    ),
    onTap: onTap,
  );
}

containerDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(defaultRadius),
    color: appStore.isDarkMode ? scaffoldColorDark : Colors.white,
    border: Border.all(color: appStore.isDarkMode ? Colors.white12 : viewLineColor,width: 1.5),
  );
}

Widget commonCachedNetworkImage(
  String? url, {
  double? height,
  double? width,
  BoxFit? fit,
  AlignmentGeometry? alignment,
  bool usePlaceholderIfUrlEmpty = true,
  double? radius,
}) {
  if (url != null && url.isEmpty) {
    return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
  } else if (url.validate().startsWith('http')) {
    return CachedNetworkImage(
      imageUrl: url!,
      height: height,
      width: width,
      fit: fit,
      alignment: alignment as Alignment? ?? Alignment.center,
      errorWidget: (_, s, d) {
        return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
      },
      placeholder: (_, s) {
        if (!usePlaceholderIfUrlEmpty) return SizedBox();
        return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
      },
    );
  } else {
    return Image.network(url!, height: height, width: width, fit: fit, alignment: alignment ?? Alignment.center);
  }
}

Widget placeHolderWidget({double? height, double? width, BoxFit? fit, AlignmentGeometry? alignment, double? radius}) {
  return Image.asset('assets/placeholder.jpg', height: height, width: width, fit: fit ?? BoxFit.cover, alignment: alignment ?? Alignment.center);
}

Widget orderItemDetail(String title, String data) {
  return Container(
    width: statisticsItemWidth,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: secondaryTextStyle(), overflow: TextOverflow.ellipsis),
        SizedBox(height: 8),
        Text(data, style: primaryTextStyle(), overflow: TextOverflow.ellipsis),
      ],
    ),
  );
}

Widget informationWidget(String title, String value) {
  return Padding(
    padding: EdgeInsets.only(bottom: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: boldTextStyle(weight: FontWeight.w500)),
        Text(value, style: primaryTextStyle()),
      ],
    ),
  );
}

Widget addButton(String title, Function() onTap) {
  return GestureDetector(
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(defaultRadius)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.add, color: Colors.white),
          SizedBox(width: 12),
          Text(title, style: boldTextStyle(color: Colors.white)),
        ],
      ),
    ),
    onTap: onTap,
  );
}

Widget dialogSecondaryButton(String title, Function() onTap) {
  return SizedBox(
    width: 120,
    height: 40,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultRadius), side: BorderSide(color: appStore.isDarkMode ? Colors.white12 : viewLineColor)),
          elevation: 0,
          primary: Colors.transparent,
          shadowColor: Colors.transparent),
      child: Text(title, style: boldTextStyle(color: Colors.grey)),
      onPressed: onTap,
    ),
  );
}

Widget dialogPrimaryButton(String title, Function() onTap, {Color? color}) {
  return SizedBox(
    width: 120,
    height: 40,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultRadius)),
        elevation: 0,
        primary: color ?? primaryColor,
      ),
      child: Text(title, style: boldTextStyle(color: Colors.white)),
      onPressed: onTap,
    ),
  );
}

Widget userDetailWidget({String? title, String? subtitle}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Text(title!, style: boldTextStyle()),
      ),
      Expanded(
        child: Text(subtitle!, style: primaryTextStyle(), maxLines: 2, overflow: TextOverflow.visible, textAlign: TextAlign.right),
      ),
    ],
  );
}

Widget paginationWidget(BuildContext context, {required int currentPage, required int totalPage, int perPage = 10, required Function(int currentPage, int perPage) onUpdate}) {
  List<int> perPageList = [5, 10, 25, 50, 100, -1];
  return Align(
    alignment: AlignmentDirectional.bottomEnd,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          padding: EdgeInsets.only(left: 12, right: 12),
          child: IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(language.perPage, style: primaryTextStyle()),
                SizedBox(width: 12),
                VerticalDivider(),
                SizedBox(width: 12),
                DropdownButton<int>(
                    underline: SizedBox(),
                    focusColor: Colors.transparent,
                    style: primaryTextStyle(),
                    dropdownColor: Theme.of(context).cardColor,
                    value: perPage,
                    items: List.generate(perPageList.length, (index) {
                      int item = perPageList[index];
                      return DropdownMenuItem(child: Text(item == -1 ? language.all : '$item'), value: item);
                    }),
                    onChanged: (value) {
                      currentPage = 1;
                      perPage = value!;
                      onUpdate.call(currentPage, perPage);
                    }),
              ],
            ),
          ),
        ),
        SizedBox(width: 16),
        Container(
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          padding: EdgeInsets.only(left: 12, right: 12),
          child: IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${language.page} $currentPage ${language.lbl_of} $totalPage', style: primaryTextStyle()),
                SizedBox(width: 12),
                VerticalDivider(),
                SizedBox(width: 12),
                DropdownButton<int>(
                    underline: SizedBox(),
                    focusColor: Colors.transparent,
                    value: currentPage,
                    style: primaryTextStyle(),
                    dropdownColor: Theme.of(context).cardColor,
                    items: List.generate(totalPage, (index) {
                      return DropdownMenuItem(child: Text('${index + 1}'), value: index + 1);
                    }),
                    onChanged: (value) {
                      currentPage = value!;
                      onUpdate.call(currentPage, perPage);
                    }),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

String parseHtmlString(String? htmlString) {
  return parse(parse(htmlString).body!.text).documentElement!.text;
}

Future<bool> isNetworkAvailable() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  return connectivityResult != ConnectivityResult.none;
}

Widget loaderWidget() {
  return Center(child: Lottie.asset('assets/loader.json', width: 70, height: 70));
}

Widget emptyWidget() {
  return Center(child: Lottie.asset('assets/no_data.json', width: 250, height: 250));
}

String printDate(String date) {
  return DateFormat.yMd().add_jm().format(DateTime.parse(date).toLocal());
}

Widget tiTleWidget({String? title, required BuildContext context}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title!, style: boldTextStyle(size: 18)),
      Container(
        decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(defaultRadius)),
        child: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      )
    ],
  );
}

Widget totalUserWidget({String? title, int? totalCount, String? image}) {
  return Container(
    width: 250,
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      boxShadow: commonBoxShadow(),
      color: appStore.isDarkMode ? scaffoldColorDark : Colors.white,
      borderRadius: BorderRadius.circular(defaultRadius),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title!, style: secondaryTextStyle(size: 16), maxLines: 1),
              SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(totalCount.toString(), style: boldTextStyle(size: 20)),
                  SizedBox(width: 6),
                ],
              ),
            ],
          ),
        ),
        SizedBox(width: 16),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(defaultRadius),
            gradient: LinearGradient(
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
              colors: [
                Colors.pink,
                Colors.purple,
              ],
            ),
          ),
          child: ImageIcon(AssetImage(image!), size: 24, color: Colors.white),
        ),
      ],
    ),
  );
}

commonConfirmationDialog(BuildContext context, String dialogType, Function() onSuccess, {bool isForceDelete = false, String? title, String? subtitle}) {
  IconData? icon;
  Color? color;
  if (dialogType == DIALOG_TYPE_DELETE) {
    icon = isForceDelete ? Icons.delete_forever : Icons.delete;
    color = Colors.red;
  } else if (dialogType == DIALOG_TYPE_RESTORE) {
    icon = Icons.restore;
    color = Colors.green;
  } else if (dialogType == DIALOG_TYPE_ENABLE) {
    color = primaryColor;
  } else if (dialogType == DIALOG_TYPE_DISABLE) {
    color = Colors.red;
  }
  showDialog<void>(
    context: context,
    barrierDismissible: false, // false = user must tap button, true = tap outside dialog
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        actionsPadding: EdgeInsets.all(16),
        content: SizedBox(
          width: 200,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon != null
                  ? Container(
                      decoration: BoxDecoration(color: color!.withOpacity(0.2), shape: BoxShape.circle),
                      padding: EdgeInsets.all(16),
                      child: Icon(icon, color: color),
                    )
                  : SizedBox(),
              SizedBox(height: 30),
              Text(title!, style: primaryTextStyle(size: 24), textAlign: TextAlign.center),
              SizedBox(height: 16),
              Text(subtitle!, style: secondaryTextStyle(), textAlign: TextAlign.center),
              SizedBox(height: 8),
              if (isForceDelete) Text(language.you_delete_this_recover_it, style: secondaryTextStyle(), textAlign: TextAlign.center),
            ],
          ),
        ),
        actions: <Widget>[
          dialogSecondaryButton(language.no, () {
            Navigator.pop(context);
          }),
          dialogPrimaryButton(language.yes, () {
            onSuccess.call();
          }, color: color),
        ],
      );
    },
  );
}

void afterBuildCreated(Function()? onCreated) {
  SchedulerBinding.instance.addPostFrameCallback((_) => onCreated?.call());
}

String orderStatus(String orderStatus) {
  if (orderStatus == ORDER_ASSIGNED) {
    return language.assign;
  } else if (orderStatus == ORDER_DRAFT) {
    return language.draft;
  } else if (orderStatus == ORDER_CREATED) {
    return language.create;
  } else if (orderStatus == ORDER_ACTIVE) {
    return language.active;
  } else if (orderStatus == ORDER_PICKED_UP) {
    return language.picked_up;
  } else if (orderStatus == ORDER_ARRIVED) {
    return language.arrived;
  } else if (orderStatus == ORDER_DEPARTED) {
    return language.departed;
  } else if (orderStatus == ORDER_COMPLETED) {
    return language.completed;
  } else if (orderStatus == ORDER_CANCELLED) {
    return language.cancelled;
  }
  return language.assign;
}

String notificationTypeIcon({String? type}) {
  String icon = 'assets/icons/ic_create.png';
  if (type == ORDER_ASSIGNED) {
    icon = 'assets/icons/ic_assign.png';
  } else if (type == ORDER_ACTIVE) {
    icon = 'assets/icons/ic_active.png';
  } else if (type == ORDER_PICKED_UP) {
    icon = 'assets/icons/ic_picked.png';
  } else if (type == ORDER_ARRIVED) {
    icon = 'assets/icons/ic_arrived.png';
  } else if (type == ORDER_DEPARTED) {
    icon = 'assets/icons/ic_departed.png';
  } else if (type == ORDER_COMPLETED) {
    icon = 'assets/icons/ic_completed.png';
  } else if (type == ORDER_CANCELLED) {
    icon = 'assets/icons/ic_cancelled.png';
  } else if (type == ORDER_CREATE) {
    icon = 'assets/icons/ic_create.png';
  } else if (type == ORDER_DRAFT) {
    icon = 'assets/icons/ic_draft.png';
  }
  return icon;
}

Future<void> logOutData({required BuildContext context}) async {
  showDialog<void>(
    context: context,
    barrierDismissible: false, // false = user must tap button, true = tap outside dialog
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        actionsPadding: EdgeInsets.all(16),
        content: SizedBox(
          width: 200,
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(color: primaryColor.withOpacity(0.2), shape: BoxShape.circle),
                    padding: EdgeInsets.all(16),
                    child: Icon(Icons.clear, color: primaryColor),
                  ),
                  SizedBox(height: 30),
                  Text(language.are_you_sure, style: primaryTextStyle(size: 24)),
                  SizedBox(height: 16),
                  Text(language.do_you_want_to_logout_from_the_app, style: boldTextStyle(), textAlign: TextAlign.center),
                  SizedBox(height: 16),
                ],
              ),
              Observer(builder: (context) => Visibility(visible:appStore.isLoading,child: Positioned.fill(child: loaderWidget()))),
            ],
          ),
        ),
        actions: <Widget>[
          dialogSecondaryButton(language.no, () {
            Navigator.pop(context);
          }),
          dialogPrimaryButton(language.yes, () async{
            appStore.setLoading(true);
            await logout(context);
            appStore.setLoading(false);
          }),
        ],
      );
    },
  );
}

Widget settingData({String? name, IconData? icon, required BuildContext context, Function()? onTap}) {
  return ListTile(
    leading: Icon(icon!, color: Theme.of(context).iconTheme.color),
    title: Text(name!, style: boldTextStyle()),
    onTap: onTap,
  );
}

Color statusColor(String status) {
  Color color = primaryColor;
  switch (status) {
    case ORDER_ACTIVE:
      return primaryColor;
    case ORDER_CANCELLED:
      return Colors.red;
    case ORDER_COMPLETED:
      return Colors.green;
    case ORDER_DRAFT:
      return Colors.grey;
    case ORDER_DELAYED:
      return Colors.grey;
  }
  return color;
}

double countExtraCharge({required num totalAmount, required String chargesType, required num charges}) {
  if (chargesType == CHARGE_TYPE_PERCENTAGE) {
    return double.parse((totalAmount * charges * 0.01).toStringAsFixed(2));
  } else {
    return double.parse(charges.toStringAsFixed(2));
  }
}

Widget backButton(BuildContext context) {
  return ElevatedButton(
    onPressed: () {
      Navigator.pop(context);
    },
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.arrow_back_ios, color: Colors.white, size: 12),
        SizedBox(width: 8),
        Text(language.back, style: primaryTextStyle(color: Colors.white)),
      ],
    ),
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.all(12),
    ),
  );
}

Widget scheduleOptionWidget({required BuildContext context, required bool isSelected, required String imagePath, required String title, required Function() onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(defaultRadius), border: Border.all(color: isSelected ? primaryColor : Theme.of(context).dividerColor), color: Theme.of(context).cardColor),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ImageIcon(AssetImage(imagePath), size: 20, color: isSelected ? primaryColor : Colors.grey),
          SizedBox(width: 16),
          Text(title, style: boldTextStyle()),
        ],
      ),
    ),
  );
}

double calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var a = 0.5 - cos((lat2 - lat1) * p) / 2 + cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
  return double.tryParse((12742 * asin(sqrt(a))).toStringAsFixed(2))!;
}

String? paymentStatus(String paymentStatus) {
  if (paymentStatus.toLowerCase() == PAYMENT_PENDING.toLowerCase()) {
    return language.pending;
  } else if (paymentStatus.toLowerCase() == PAYMENT_FAILED.toLowerCase()) {
    return language.failed;
  } else if (paymentStatus.toLowerCase() == PAYMENT_PAID.toLowerCase()) {
    return language.paid;
  }
  return language.pending;
}

String? paymentCollectForm(String paymentType) {
  if (paymentType.toLowerCase() == PAYMENT_ON_PICKUP.toLowerCase()) {
    return language.on_pickup;
  } else if (paymentType.toLowerCase() == PAYMENT_ON_DELIVERY.toLowerCase()) {
    return language.on_delivery;
  }
  return language.on_pickup;
}

String? paymentType(String paymentType) {
  if (paymentType.toLowerCase() == PAYMENT_GATEWAY_STRIPE.toLowerCase()) {
    return language.stripe;
  } else if (paymentType.toLowerCase() == PAYMENT_GATEWAY_RAZORPAY.toLowerCase()) {
    return language.razorpay;
  } else if (paymentType.toLowerCase() == PAYMENT_GATEWAY_PAYSTACK.toLowerCase()) {
    return language.pay_stack;
  } else if (paymentType.toLowerCase() == PAYMENT_GATEWAY_FLUTTERWAVE.toLowerCase()) {
    return language.flutter_wave;
  } else if (paymentType.toLowerCase() == PAYMENT_GATEWAY_MERCADOPAGO.toLowerCase()) {
    return language.mercado_pago;
  } else if (paymentType.toLowerCase() == PAYMENT_GATEWAY_PAYPAL.toLowerCase()) {
    return language.paypal;
  } else if (paymentType.toLowerCase() == PAYMENT_GATEWAY_PAYTABS.toLowerCase()) {
    return language.paytabs;
  } else if (paymentType.toLowerCase() == PAYMENT_GATEWAY_PAYTM.toLowerCase()) {
    return language.paytm;
  } else if (paymentType.toLowerCase() == PAYMENT_GATEWAY_MYFATOORAH.toLowerCase()) {
    return language.my_fatoorah;
  } else if (paymentType.toLowerCase() == PAYMENT_TYPE_CASH.toLowerCase()) {
    return language.cash;
  }
  return language.cash;
}

String statusTypeIcon({String? type}) {
  String icon = 'assets/icons/ic_create.png';
  if (type == ORDER_ASSIGNED) {
    icon = 'assets/icons/ic_assign.png';
  } else if (type == ORDER_ACTIVE) {
    icon = 'assets/icons/ic_active.png';
  } else if (type == ORDER_PICKED_UP) {
    icon = 'assets/icons/ic_picked.png';
  } else if (type == ORDER_ARRIVED) {
    icon = 'assets/icons/ic_arrived.png';
  } else if (type == ORDER_DEPARTED) {
    icon = 'assets/icons/ic_departed.png';
  } else if (type == ORDER_COMPLETED) {
    icon = 'assets/icons/ic_completed.png';
  } else if (type == ORDER_CANCELLED) {
    icon = 'assets/icons/ic_cancelled.png';
  } else if (type == ORDER_CREATE) {
    icon = 'assets/icons/ic_create.png';
  } else if (type == ORDER_DRAFT) {
    icon = 'assets/icons/ic_draft.png';
  }
  return icon;
}

Future<void> saveFcmTokenId() async {
  await FirebaseMessaging.instance.getToken().then((value) {
     if (value!.isNotEmpty.validate()) shared_pref.setString(FCM_TOKEN, value.validate());
  });
}

String printAmount(num amount){
  return appStore.currencyPosition==CURRENCY_POSITION_LEFT ? '${appStore.currencySymbol} $amount' : '$amount ${appStore.currencySymbol}';
}
