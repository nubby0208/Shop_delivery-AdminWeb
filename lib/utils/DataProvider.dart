import 'package:local_delivery_admin/components/CityWidget.dart';
import 'package:local_delivery_admin/components/CountryWidget.dart';
import 'package:local_delivery_admin/components/CreateOrderWidget.dart';
import 'package:local_delivery_admin/components/DeliveryBoyWidget.dart';
import 'package:local_delivery_admin/components/ExtraChargesWidget.dart';
import 'package:local_delivery_admin/components/HomeWidget.dart';
import 'package:local_delivery_admin/components/OrderWidget.dart';
import 'package:local_delivery_admin/components/ParcelTypeWidget.dart';
import 'package:local_delivery_admin/components/PaymentGatewayWidget.dart';
import 'package:local_delivery_admin/components/UserWidget.dart';
import 'package:local_delivery_admin/main.dart';
import 'package:local_delivery_admin/models/LanguageDataModel.dart';
import 'package:local_delivery_admin/models/AppSettingModel.dart';
import 'package:local_delivery_admin/models/models.dart';
import 'package:local_delivery_admin/utils/Constants.dart';

import '../components/DeliveryPersonDocumentWidget.dart';
import '../components/DocumentWidget.dart';
import '../screens/AppSettingScreen.dart';

List<MenuItemModel> getMenuItems() {
  List<MenuItemModel> list = [];
  list.add(MenuItemModel(index: DASHBOARD_INDEX, imagePath: 'assets/icons/ic_dashboard.png', title: language.dashboard, widget: HomeWidget()));
  list.add(MenuItemModel(index: COUNTRY_INDEX, imagePath: 'assets/icons/ic_country.png', title: language.country, widget: CountryWidget()));
  list.add(MenuItemModel(index: CITY_INDEX, imagePath: 'assets/icons/ic_city.png', title: language.city, widget: CityWidget()));
  list.add(MenuItemModel(index: EXTRA_CHARGES_INDEX, imagePath: 'assets/icons/ic_extra_charges.png', title: language.extra_charges, widget: ExtraChargesWidget()));
  list.add(MenuItemModel(index: PARCEL_TYPE_INDEX, imagePath: 'assets/icons/ic_parcel_type.png', title: language.parcel_type, widget: ParcelTypeWidget()));
  list.add(MenuItemModel(index: PAYMENT_GATEWAY_INDEX, imagePath: 'assets/icons/ic_payment_gateway.png', title: language.payment_gateway, widget: PaymentGatewayWidget()));
  list.add(MenuItemModel(index: CREATE_ORDER_INDEX, imagePath: 'assets/icons/ic_create_order.png', title: language.create_order, widget: CreateOrderWidget()));
  list.add(MenuItemModel(index: ORDER_INDEX, imagePath: 'assets/icons/ic_orders.png', title: language.all_order, widget: OrderWidget()));
  list.add(MenuItemModel(index: DOCUMENT_INDEX, imagePath: 'assets/icons/ic_document.png', title: language.document, widget: DocumentWidget()));
  list.add(MenuItemModel(index: DELIVERY_PERSON_DOCUMENT_INDEX, imagePath: 'assets/icons/ic_document.png', title: language.delivery_person_documents, widget: DeliveryPersonDocumentWidget()));
  list.add(MenuItemModel(index: USER_INDEX, imagePath: 'assets/icons/ic_users.png', title: language.users, widget: UserWidget()));
  list.add(MenuItemModel(index: DELIVERY_PERSON_INDEX, imagePath: 'assets/icons/ic_delivery_boy.png', title: language.delivery_person, widget: DeliveryBoyWidget()));
  list.add(MenuItemModel(index: APP_SETTING_INDEX, imagePath: 'assets/icons/ic_notification_setting.png', title: language.appSetting, widget: AppSettingScreen()));
  return list;
}

List<StaticPaymentModel> getStaticPaymentItems() {
  List<StaticPaymentModel> list = [];
  list.add(StaticPaymentModel(title: language.stripe, type: PAYMENT_GATEWAY_STRIPE));
  list.add(StaticPaymentModel(title: language.razorpay, type: PAYMENT_GATEWAY_RAZORPAY));
  list.add(StaticPaymentModel(title: language.flutter_wave, type: PAYMENT_GATEWAY_FLUTTERWAVE));
  list.add(StaticPaymentModel(title: language.paypal, type: PAYMENT_GATEWAY_PAYPAL));
  list.add(StaticPaymentModel(title: language.paytabs, type: PAYMENT_GATEWAY_PAYTABS));
  list.add(StaticPaymentModel(title: language.mercado_pago, type: PAYMENT_GATEWAY_MERCADOPAGO));
  list.add(StaticPaymentModel(title: language.paytm, type: PAYMENT_GATEWAY_PAYTM));
  list.add(StaticPaymentModel(title: language.my_fatoorah, type: PAYMENT_GATEWAY_MYFATOORAH));
  return list;
}

List<LanguageDataModel> languageList() {
  return [
    LanguageDataModel(id: 1, name: 'English', subTitle: 'English', languageCode: 'en', fullLanguageCode: 'en-US', flag: 'assets/flag/ic_us.png'),
    LanguageDataModel(id: 2, name: 'Hindi', subTitle: 'हिंदी', languageCode: 'hi', fullLanguageCode: 'hi-IN', flag: 'assets/flag/ic_india.png'),
    LanguageDataModel(id: 3, name: 'Arabic', subTitle: 'عربي', languageCode: 'ar', fullLanguageCode: 'ar-AR', flag: 'assets/flag/ic_ar.png'),
    LanguageDataModel(id: 1, name: 'Spanish', subTitle: 'Española', languageCode: 'es', fullLanguageCode: 'es-ES', flag: 'assets/flag/ic_spain.png'),
    LanguageDataModel(id: 2, name: 'Afrikaans', subTitle: 'Afrikaans', languageCode: 'af', fullLanguageCode: 'af-AF', flag: 'assets/flag/ic_south_africa.png'),
    LanguageDataModel(id: 3, name: 'French', subTitle: 'Français', languageCode: 'fr', fullLanguageCode: 'fr-FR', flag: 'assets/flag/ic_france.png'),
    LanguageDataModel(id: 1, name: 'German', subTitle: 'Deutsch', languageCode: 'de', fullLanguageCode: 'de-DE', flag: 'assets/flag/ic_germany.png'),
    LanguageDataModel(id: 2, name: 'Indonesian', subTitle: 'bahasa Indonesia', languageCode: 'id', fullLanguageCode: 'id-ID', flag: 'assets/flag/ic_indonesia.png'),
    LanguageDataModel(id: 3, name: 'Portuguese', subTitle: 'Português', languageCode: 'pt', fullLanguageCode: 'pt-PT', flag: 'assets/flag/ic_portugal.png'),
    LanguageDataModel(id: 1, name: 'Turkish', subTitle: 'Türkçe', languageCode: 'tr', fullLanguageCode: 'tr-TR', flag: 'assets/flag/ic_turkey.png'),
    LanguageDataModel(id: 2, name: 'vietnamese', subTitle: 'Tiếng Việt', languageCode: 'vi', fullLanguageCode: 'vi-VI', flag: 'assets/flag/ic_vitnam.png'),
    LanguageDataModel(id: 3, name: 'Dutch', subTitle: 'Nederlands', languageCode: 'nl', fullLanguageCode: 'nl-NL', flag: 'assets/flag/ic_dutch.png'),
  ];
}

String? orderSettingStatus(String orderStatus) {
  if (orderStatus == ORDER_CREATE) {
    return language.create;
  } else if (orderStatus == ORDER_ACTIVE) {
    return language.active;
  } else if (orderStatus == ORDER_ASSIGNED) {
    return language.courier_assigned;
  } else if (orderStatus == ORDER_TRANSFER) {
    return language.courier_transfer;
  } else if (orderStatus == ORDER_ARRIVED) {
    return language.courier_arrived;
  } else if (orderStatus == ORDER_DELAYED) {
    return language.delayed;
  } else if (orderStatus == ORDER_CANCELLED) {
    return language.cancel;
  } else if (orderStatus == ORDER_PICKED_UP) {
    return language.courier_picked_up;
  } else if (orderStatus == ORDER_DEPARTED) {
    return language.courier_departed;
  } else if (orderStatus == ORDER_PAYMENT) {
    return language.payment_status_message;
  } else if (orderStatus == ORDER_FAIL) {
    return language.failed;
  } else if (orderStatus == ORDER_COMPLETED) {
    return language.completed;
  }
  return ORDER_CREATE;
}

Map<String, dynamic> getNotificationSetting() {
  List<NotificationSettings> list = [];
  list.add(NotificationSettings(active: Notifications(isOnesignalNotification: '0', isFirebaseNotification: '0')));
  list.add(NotificationSettings(create: Notifications(isOnesignalNotification: '0', isFirebaseNotification: '0')));
  list.add(NotificationSettings(courier_assigned: Notifications(isOnesignalNotification: '0', isFirebaseNotification: '0')));
  list.add(NotificationSettings(courier_transfer: Notifications(isOnesignalNotification: '0', isFirebaseNotification: '0')));
  list.add(NotificationSettings(courier_arrived: Notifications(isOnesignalNotification: '0', isFirebaseNotification: '0')));
  list.add(NotificationSettings(delayed: Notifications(isOnesignalNotification: '0', isFirebaseNotification: '0')));
  list.add(NotificationSettings(cancelled: Notifications(isOnesignalNotification: '0', isFirebaseNotification: '0')));
  list.add(NotificationSettings(courier_picked_up: Notifications(isOnesignalNotification: '0', isFirebaseNotification: '0')));
  list.add(NotificationSettings(courier_departed: Notifications(isOnesignalNotification: '0', isFirebaseNotification: '0')));
  list.add(NotificationSettings(completed: Notifications(isOnesignalNotification: '0', isFirebaseNotification: '0')));
  list.add(NotificationSettings(payment_status_message: Notifications(isOnesignalNotification: '0', isFirebaseNotification: '0')));
  list.add(NotificationSettings(failed: Notifications(isOnesignalNotification: '0', isFirebaseNotification: '0')));

  Map<String, dynamic> map = Map.fromIterable(list, key: (e) => e.toJson().keys.first.toString(), value: (e) => e.toJson().values.first);

  return map;
}
