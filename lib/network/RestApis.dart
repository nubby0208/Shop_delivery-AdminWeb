import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:local_delivery_admin/models/AutoCompletePlacesListModel.dart';
import 'package:local_delivery_admin/models/CityListModel.dart';
import 'package:local_delivery_admin/models/CountryListModel.dart';
import 'package:local_delivery_admin/models/DashboardModel.dart';
import 'package:local_delivery_admin/models/DeliveryDocumentListModel.dart';
import 'package:local_delivery_admin/models/DocumentListModel.dart';
import 'package:local_delivery_admin/models/ExtraChragesListModel.dart';
import 'package:local_delivery_admin/models/LDBaseResponse.dart';
import 'package:local_delivery_admin/models/LoginResponse.dart';
import 'package:local_delivery_admin/models/NotificationModel.dart';
import 'package:local_delivery_admin/models/AppSettingModel.dart';
import 'package:local_delivery_admin/models/OrderDetailModel.dart';
import 'package:local_delivery_admin/models/OrderListModel.dart';
import 'package:local_delivery_admin/models/ParcelTypeListModel.dart';
import 'package:local_delivery_admin/models/PaymentGatewayListModel.dart';
import 'package:local_delivery_admin/models/PlaceIdDetailModel.dart';
import 'package:local_delivery_admin/models/UpdateUserStatus.dart';
import 'package:local_delivery_admin/models/UserListModel.dart';
import 'package:local_delivery_admin/models/UserModel.dart';
import 'package:local_delivery_admin/network/NetworkUtils.dart';
import 'package:local_delivery_admin/screens/LoginScreen.dart';
import 'package:local_delivery_admin/utils/Constants.dart';
import 'package:local_delivery_admin/utils/Extensions/StringExtensions.dart';
import 'package:local_delivery_admin/utils/Extensions/app_common.dart';

import '../main.dart';

Future<LoginResponse> logInApi(Map request) async {
  Response response = await buildHttpResponse('login', request: request, method: HttpMethod.POST);

  if (!(response.statusCode >= 200 && response.statusCode <= 206)) {
    if (response.body.isJson()) {
      var json = jsonDecode(response.body);

      if (json.containsKey('code') && json['code'].toString().contains('invalid_username')) {
        throw 'invalid_username';
      }
    }
  }

  return await handleResponse(response).then((json) async {
    var loginResponse = LoginResponse.fromJson(json);
    await shared_pref.setString(TOKEN, loginResponse.data!.apiToken.validate());
    await shared_pref.setInt(USER_ID, loginResponse.data!.id!);
    await shared_pref.setString(USER_TYPE, loginResponse.data!.userType!);
    await shared_pref.setString(USER_EMAIL, loginResponse.data!.email.validate());
    await shared_pref.setString(USER_PASSWORD, request['password']);
    await shared_pref.setString(NAME, loginResponse.data!.name.validate());
    await shared_pref.setString(USER_PROFILE_PHOTO, loginResponse.data!.profileImage.validate());
    await shared_pref.setString(USER_CONTACT_NUMBER, loginResponse.data!.contactNumber.validate());
    await shared_pref.setString(USER_NAME, loginResponse.data!.username.validate());
    await shared_pref.setString(USER_ADDRESS, loginResponse.data!.address.validate());

    appStore.setUserProfile(loginResponse.data!.profileImage!.validate());

    await appStore.setLoggedIn(true);
    return loginResponse;
  }).catchError((e) {
    throw e.toString();
  });
}

Future<void> logout(BuildContext context, {bool isFromLogin = false}) async {
  await logoutApi().then((value) async {
    await shared_pref.remove(TOKEN);
    await shared_pref.remove(IS_LOGGED_IN);
    await shared_pref.remove(USER_ID);
    await shared_pref.remove(USER_TYPE);
    await shared_pref.remove(USER_EMAIL);
    await shared_pref.remove(USER_PASSWORD);
    await shared_pref.remove(FCM_TOKEN);
    await shared_pref.remove(NAME);
    await shared_pref.remove(USER_PROFILE_PHOTO);
    await shared_pref.remove(USER_CONTACT_NUMBER);
    await shared_pref.remove(USER_NAME);
    await shared_pref.remove(USER_ADDRESS);

    await appStore.setLoggedIn(false);
    if (isFromLogin) {
      toast('These credential do not match our records');
    } else {
      launchScreen(context, LoginScreen(), isNewTask: true);
    }
  }).catchError((e) {
    throw e.toString();
  });
}

/// Profile Update
Future updateProfile({String? userName, String? name, String? userEmail, String? address, String? contactNumber, Uint8List? image, String? fileName}) async {
  MultipartRequest multiPartRequest = await getMultiPartRequest('update-profile');
  multiPartRequest.fields['id'] = shared_pref.getInt(USER_ID).toString();
  multiPartRequest.fields['username'] = userName ?? shared_pref.getString(USER_NAME).validate();
  multiPartRequest.fields['email'] = userEmail ?? shared_pref.getString(USER_EMAIL).validate();
  multiPartRequest.fields['name'] = name ?? shared_pref.getString(NAME).validate();
  multiPartRequest.fields['contact_number'] = contactNumber ?? shared_pref.getString(USER_CONTACT_NUMBER).validate();
  multiPartRequest.fields['address'] = address ?? shared_pref.getString(USER_CONTACT_NUMBER).validate();

  if (image != null) {
    print('Call');
    multiPartRequest.files.add(await MultipartFile.fromBytes('profile_image', image, filename: fileName));
  }

  print('req: ${multiPartRequest.fields} ${multiPartRequest.files}');
  await sendMultiPartRequest(multiPartRequest, onSuccess: (data) async {
    if (data != null) {
      LoginResponse res = LoginResponse.fromJson(data);

      await shared_pref.setString(NAME, res.data!.name.validate());
      await shared_pref.setString(USER_NAME, res.data!.username.validate());
      await shared_pref.setString(USER_ADDRESS, res.data!.address.validate());
      await shared_pref.setString(USER_CONTACT_NUMBER, res.data!.contactNumber.validate());
      await shared_pref.setString(USER_EMAIL, res.data!.email.validate());
      appStore.setUserProfile(res.data!.profileImage.validate());
    }
  }, onError: (error) {
    toast(error.toString());
  });
}

Future<LDBaseResponse> forgotPassword(Map req) async {
  return LDBaseResponse.fromJson(await handleResponse(await buildHttpResponse('forget-password', request: req, method: HttpMethod.POST)));
}

Future<LDBaseResponse> changePassword(Map req) async {
  return LDBaseResponse.fromJson(await handleResponse(await buildHttpResponse('change-password', request: req, method: HttpMethod.POST)));
}

// User Api
Future<UserListModel> getAllUserList({String? type, int? perPage, int? page}) async {
  return UserListModel.fromJson(await handleResponse(await buildHttpResponse('user-list?user_type=$type&page=$page&is_deleted=1&per_page=$perPage', method: HttpMethod.GET)));
}

Future<UpdateUserStatus> updateUserStatus(Map req) async {
  return UpdateUserStatus.fromJson(await handleResponse(await buildHttpResponse('update-user-status', request: req, method: HttpMethod.POST)));
}

Future<LDBaseResponse> deleteUser(Map req) async {
  return LDBaseResponse.fromJson(await handleResponse(await buildHttpResponse('delete-user', request: req, method: HttpMethod.POST)));
}

Future<LDBaseResponse> userAction(Map request) async {
  return LDBaseResponse.fromJson(await handleResponse(await buildHttpResponse('user-action', request: request, method: HttpMethod.POST)));
}

Future<UserModel> getUserDetail(int id) async {
  return UserModel.fromJson(await handleResponse(await buildHttpResponse('user-detail?id=$id', method: HttpMethod.GET)).then((value) => value['data']));
}

// Country Api
Future<CountryListModel> getCountryList({int? page, bool isDeleted = false, int perPage = 10}) async {
  return CountryListModel.fromJson(
      await handleResponse(await buildHttpResponse(page != null ? 'country-list?page=$page&is_deleted=${isDeleted ? 1 : 0}&per_page=$perPage' : 'country-list?per_page=-1&is_deleted=${isDeleted ? 1 : 0}', method: HttpMethod.GET)));
}

Future<LDBaseResponse> addCountry(Map request) async {
  return LDBaseResponse.fromJson(await handleResponse(await buildHttpResponse('country-save', request: request, method: HttpMethod.POST)));
}

Future<LDBaseResponse> deleteCountry(int id) async {
  return LDBaseResponse.fromJson(await handleResponse(await buildHttpResponse('country-delete/$id', method: HttpMethod.POST)));
}

Future<CountryData> getCountryDetail(int id) async {
  return CountryData.fromJson(await handleResponse(await buildHttpResponse('country-detail?id=$id', method: HttpMethod.GET)).then((value) => value['data']));
}

Future<LDBaseResponse> countryAction(Map request) async {
  return LDBaseResponse.fromJson(await handleResponse(await buildHttpResponse('country-action', request: request, method: HttpMethod.POST)));
}

// City Api
Future<CityListModel> getCityList({int? page, bool isDeleted = false, int? countryId, int? perPage = 10}) async {
  if (countryId == null) {
    return CityListModel.fromJson(await handleResponse(
        await buildHttpResponse(page != null ? 'city-list?page=$page&is_deleted=${isDeleted ? 1 : 0}&per_page=$perPage' : 'city-list?per_page=-1&is_deleted=${isDeleted ? 1 : 0}&per_page=$perPage', method: HttpMethod.GET)));
  } else {
    return CityListModel.fromJson(await handleResponse(await buildHttpResponse('city-list?per_page=-1&country_id=$countryId', method: HttpMethod.GET)));
  }
}

Future<LDBaseResponse> addCity(Map request) async {
  return LDBaseResponse.fromJson(await handleResponse(await buildHttpResponse('city-save', request: request, method: HttpMethod.POST)));
}

Future<LDBaseResponse> deleteCity(int id) async {
  return LDBaseResponse.fromJson(await handleResponse(await buildHttpResponse('city-delete/$id', method: HttpMethod.POST)));
}

Future<LDBaseResponse> cityAction(Map request) async {
  return LDBaseResponse.fromJson(await handleResponse(await buildHttpResponse('city-action', request: request, method: HttpMethod.POST)));
}

Future<CityData> getCityDetail(int id) async {
  return CityData.fromJson(await handleResponse(await buildHttpResponse('city-detail?id=$id', method: HttpMethod.GET)).then((value) => value['data']));
}

// ExtraCharge Api
Future<ExtraChargesListModel> getExtraChargeList({int? page, bool isDeleted = false, int perPage = 10}) async {
  return ExtraChargesListModel.fromJson(await handleResponse(await buildHttpResponse('extracharge-list?page=$page&is_deleted=${isDeleted ? 1 : 0}&per_page=$perPage', method: HttpMethod.GET)));
}

Future<LDBaseResponse> addExtraCharge(Map request) async {
  return LDBaseResponse.fromJson(await handleResponse(await buildHttpResponse('extracharge-save', request: request, method: HttpMethod.POST)));
}

Future<LDBaseResponse> deleteExtraCharge(int id) async {
  return LDBaseResponse.fromJson(await handleResponse(await buildHttpResponse('extracharge-delete/$id', method: HttpMethod.POST)));
}

Future<LDBaseResponse> extraChargeAction(Map request) async {
  return LDBaseResponse.fromJson(await handleResponse(await buildHttpResponse('extracharge-action', request: request, method: HttpMethod.POST)));
}

// Document Api
Future<DocumentListModel> getDocumentList({int? page, bool isDeleted = false, int perPage = 10}) async {
  return DocumentListModel.fromJson(await handleResponse(await buildHttpResponse('document-list?page=$page&is_deleted=${isDeleted ? 1 : 0}&per_page=$perPage', method: HttpMethod.GET)));
}

Future<LDBaseResponse> addDocument(Map request) async {
  return LDBaseResponse.fromJson(await handleResponse(await buildHttpResponse('document-save', request: request, method: HttpMethod.POST)));
}

Future<LDBaseResponse> deleteDocument(int id) async {
  return LDBaseResponse.fromJson(await handleResponse(await buildHttpResponse('document-delete/$id', method: HttpMethod.POST)));
}

Future<LDBaseResponse> documentAction(Map request) async {
  return LDBaseResponse.fromJson(await handleResponse(await buildHttpResponse('document-action', request: request, method: HttpMethod.POST)));
}

// Delivery Man Documents
Future<DeliveryDocumentListModel> getDeliveryDocumentList({int? page, bool isDeleted = false, int? deliveryManId, int? perPage = 10}) async {
  return DeliveryDocumentListModel.fromJson(await handleResponse(await buildHttpResponse(
      deliveryManId != null
          ? 'delivery-man-document-list?page=$page&is_deleted=${isDeleted ? 1 : 0}&delivery_man_id=$deliveryManId&per_page=$perPage'
          : 'delivery-man-document-list?page=$page&is_deleted=${isDeleted ? 1 : 0}&per_page=$perPage',
      method: HttpMethod.GET)));
}

/// Create Order Api
Future<LDBaseResponse> createOrder(Map request) async {
  return LDBaseResponse.fromJson(await handleResponse(await buildHttpResponse('order-save', request: request, method: HttpMethod.POST)));
}

// Order Api
Future<OrderListModel> getAllOrder({int? page, int perPage = 10, String? status}) async {
  return OrderListModel.fromJson(
      await handleResponse(await buildHttpResponse(status != null ? 'order-list?page=$page&status=$status&per_page=$perPage' : 'order-list?page=$page&status=trashed&per_page=$perPage', method: HttpMethod.GET)));
}

// ParcelType Api
Future<ParcelTypeListModel> getParcelTypeList({int? page, int perPage = 10}) async {
  return ParcelTypeListModel.fromJson(
      await handleResponse(await buildHttpResponse(page != null ? 'staticdata-list?type=parcel_type&page=$page&per_page=$perPage' : 'staticdata-list?type=parcel_type&per_page=-1', method: HttpMethod.GET)));
}

Future<LDBaseResponse> addParcelType(Map request) async {
  return LDBaseResponse.fromJson(await handleResponse(await buildHttpResponse('staticdata-save', request: request, method: HttpMethod.POST)));
}

Future<LDBaseResponse> deleteParcelType(int id) async {
  return LDBaseResponse.fromJson(await handleResponse(await buildHttpResponse('staticdata-delete/$id', method: HttpMethod.POST)));
}

// Payment Gateway Api
Future<PaymentGatewayListModel> getPaymentGatewayList() async {
  return PaymentGatewayListModel.fromJson(await handleResponse(await buildHttpResponse('paymentgateway-list?perPage=-1', method: HttpMethod.GET)));
}

Future<MultipartRequest> getMultiPartRequest(String endPoint, {String? baseUrl}) async {
  String url = '${baseUrl ?? buildBaseUrl(endPoint).toString()}';
  return MultipartRequest('POST', Uri.parse(url));
}

Future<void> sendMultiPartRequest(MultipartRequest multiPartRequest, {Function(dynamic)? onSuccess, Function(dynamic)? onError}) async {
  multiPartRequest.headers.addAll(buildHeaderTokens());
  http.Response response = await http.Response.fromStream(await multiPartRequest.send());

  if (response.statusCode >= 200 && response.statusCode <= 206) {
    onSuccess?.call(jsonDecode(response.body));
  } else {
    onError?.call('Something Went Wrong');
  }
}

// Dashboard Api
Future<DashboardModel> getDashBoardData() async {
  return DashboardModel.fromJson(await handleResponse(await buildHttpResponse('dashboard-detail', method: HttpMethod.GET)));
}

Future<LDBaseResponse> getRestoreOrderApi(Map req) async {
  return LDBaseResponse.fromJson(await handleResponse(await buildHttpResponse('order-action', request: req, method: HttpMethod.POST)));
}

Future<LDBaseResponse> deleteOrderApi(int OrderId) async {
  return LDBaseResponse.fromJson(await handleResponse(await buildHttpResponse('order-delete/$OrderId', method: HttpMethod.POST)));
}

Future<UserListModel> getAllDeliveryBoyList({String? type, int? page, int? cityID, int? countryId, int? perPage = 10}) async {
  return UserListModel.fromJson(await handleResponse(await buildHttpResponse('user-list?user_type=$type&page=$page&country_id=$countryId&city_id=$cityID&status=1&per_page=$perPage', method: HttpMethod.GET)));
}

Future<LDBaseResponse> orderAssign(Map req) async {
  return LDBaseResponse.fromJson(await handleResponse(await buildHttpResponse('order-action', request: req, method: HttpMethod.POST)));
}

Future<OrderDetailModel> orderDetail({required int orderId}) async {
  return OrderDetailModel.fromJson(await handleResponse(await buildHttpResponse('order-detail?id=$orderId', method: HttpMethod.GET)));
}

Future<NotificationModel> getNotification({required int page}) async {
  return NotificationModel.fromJson(await handleResponse(await buildHttpResponse('notification-list?limit=20&page=$page', method: HttpMethod.POST)));
}

Future<AppSettingModel> getAppSetting() async {
  return AppSettingModel.fromJson(await handleResponse(await buildHttpResponse('get-appsetting', method: HttpMethod.GET)));
}

Future<LDBaseResponse> setNotification(Map req) async {
  return LDBaseResponse.fromJson(await handleResponse(await buildHttpResponse('update-appsetting', request: req, method: HttpMethod.POST)));
}

Future<AutoCompletePlacesListModel> placeAutoCompleteApi({String searchText = '', String countryCode = "in", String language = 'en'}) async {
  return AutoCompletePlacesListModel.fromJson(await handleResponse(await buildHttpResponse('place-autocomplete-api?country_code=$countryCode&language=$language&search_text=$searchText', method: HttpMethod.GET)));
}

Future<PlaceIdDetailModel> getPlaceDetail({String placeId = ''}) async {
  return PlaceIdDetailModel.fromJson(await handleResponse(await buildHttpResponse('place-detail-api?placeid=$placeId', method: HttpMethod.GET)));
}

Future<LDBaseResponse> logoutApi() async {
  return LDBaseResponse.fromJson(await handleResponse(await buildHttpResponse('logout?clear=fcm_token', method: HttpMethod.GET)));
}
