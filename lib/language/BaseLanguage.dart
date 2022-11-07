import 'package:flutter/material.dart';

abstract class BaseLanguage {
  static BaseLanguage? of(BuildContext context) => Localizations.of<BaseLanguage>(context, BaseLanguage);

  String get app_name;

  String get update_city;

  String get add_city;

  String get city_name;

  String get select_country;

  String get fixed_charge;

  String get cancel_charge;

  String get minimum_distance;

  String get minimum_weight;

  String get per_distance_charge;

  String get per_weight_charge;

  String get cancel;

  String get update;

  String get add;

  String get km;

  String get miter;

  String get kg;

  String get pound;

  String get update_country;

  String get add_country;

  String get country_name;

  String get distance_type;

  String get weight_type;

  String get please_select_charge_type;

  String get update_extra_charge;

  String get add_extra_charge;

  String get country;

  String get city;

  String get title;

  String get charge;

  String get charge_type;

  String get update_parcel_type;

  String get add_parcel_type;

  String get label;

  String get value;

  String get city_id;

  String get created_date;

  String get updated_date;

  String get id;

  String get status;

  String get actions;

  String get enable;

  String get disable;

  String get you_cannot_update_status_record_deleted;

  String get delivery_boy;

  String get register_date;

  String get assign;

  String get assign_order;

  String get order_transfer;

  String get extra_charges;

  String get total_delivery_person;

  String get total_country;

  String get total_city;

  String get total_order;

  String get recent_user;

  String get recent_delivery;

  String get recent_order;

  String get order_id;

  String get customer_name;

  String get delivery_person;

  String get pickup_date;

  String get upcoming_order;

  String get view_all;

  String get orders;

  String get pickup_address;

  String get order_draft;

  String get order_deleted;

  String get parcel_type;

  String get add_parcel_types;

  String get created;

  String get payment_gateway;

  String get setup;

  String get payment_method;

  String get image;

  String get mode;

  String get test;

  String get live;

  String get users;

  String get weekly_order_count;

  String get weekly_user_count;

  String get logout;

  String get admin_sign_in;

  String get sign_in_your_account;

  String get email;

  String get login;

  String get all_notification;

  String get notification;

  String get subject;

  String get type;

  String get message;

  String get create_date;

  String get order_detail;

  String get package_information;

  String get weight;

  String get payment_information;

  String get payment_type;

  String get cash;

  String get payment_collect_form;

  String get delivery;

  String get payment_status;

  String get cod;

  String get delivery_address;

  String get delivered_at;

  String get picUp_signature;

  String get delivery_signature;

  String get total_distance;

  String get fixed_charges;

  String get total_charges;

  String get payment_gateway_setup;

  String get payment;

  String get secret_key;

  String get publishable_key;

  String get key_id;

  String get secret_id;

  String get public_key;

  String get encryption_key;

  String get select_file;

  String get save;

  String get please_select_payment_gateway_mode;

  String get do_you_really_want_to_delete_this_record;

  String get do_you_really_want_to_restore_this_record;

  String get do_you_really_want_to_enable_this_record;

  String get do_you_really_want_to_disable_this_record;

  String get field_required_msg;

  String get name;

  String get email_id;

  String get total_user;

  String get password;

  String get delivery_charges;

  String get distance_charge;

  String get weight_charge;

  String get are_you_sure;

  String get do_you_want_to_logout_from_the_app;

  String get yes;

  String get dashboard;

  String get all_order;

  String get setting;

  String get select_language;

  String get select_theme;

  String get about_us;

  String get help_support;

  String get notification_setting;

  String get one_single;

  String get create;

  String get active;

  String get courier_assigned;

  String get courier_transfer;

  String get courier_arrived;

  String get delayed;

  String get courier_picked_up;

  String get courier_departed;

  String get payment_status_message;

  String get failed;

  String get you_delete_this_recover_it;

  String get draft;

  String get picked_up;

  String get arrived;

  String get departed;

  String get completed;

  String get cancelled;

  String get demo_admin_msg;

  String get no;

  String get restore_city;

  String get do_you_want_to_restore_this_city;

  String get delete_city;

  String get do_you_want_to_delete_this_city;

  String get restore_country;

  String get do_you_want_to_restore_this_country;

  String get delete_country;

  String get do_you_want_to_delete_this_country;

  String get delete_parcel_type;

  String get do_you_want_to_delete_this_parcel_type;

  String get restore_order;

  String get do_you_want_to_restore_this_order;

  String get delete_order;

  String get do_you_want_to_delete_this_order;

  String get restore_extraCharges;

  String get do_you_want_to_restore_this_extra_charges;

  String get delete_extra_charges;

  String get do_you_want_to_delete_this_extra_charges;

  String get enable_user;

  String get disable_user;

  String get do_you_want_to_enable_this_user;

  String get do_you_want_to_disable_this_user;

  String get enable_delivery_person;

  String get disable_delivery_person;

  String get do_you_want_to_enable_this_delivery_person;

  String get do_you_want_to_disable_this_delivery_person;

  String get enable_payment;

  String get disable_payment;

  String get do_you_want_to_enable_this_payment;

  String get do_you_want_to_disable_this_payment;

  String get edit;

  String get restore;

  String get delete;

  String get force_delete;

  String get view;

  String get theme;

  String get page;

  String get lbl_of;

  String get order;

  String get transfer;

  String get restore_delivery_person;

  String get restore_delivery_person_msg;

  String get delete_delivery_person;

  String get delete_delivery_person_msg;

  String get user_deleted;

  String get delivery_person_deleted;

  String get restore_user;

  String get restore_user_msg;

  String get delete_user;

  String get delete_user_msg;

  String get delivery_person_documents;

  String get delivery_person_name;

  String get document_name;

  String get document;

  String get verified;

  String get verify_document;

  String get do_you_want_to_verify_document;

  String get verify;

  String get add_document;

  String get required;

  String get enable_document;

  String get disable_document;

  String get enable_document_msg;

  String get disable_document_msg;

  String get restore_document;

  String get restore_document_msg;

  String get delete_document;

  String get delete_document_msg;

  String get picked_at;

  String get no_data;

  String get total;

  String get back;

  String get enable_city;

  String get disable_city;

  String get enable_city_msg;

  String get disable_city_msg;

  String get enable_country;

  String get disable_country;

  String get enable_country_msg;

  String get disable_country_msg;

  String get is_verified;

  String get enable_extra_charge;

  String get disable_extra_charge;

  String get enable_extra_charge_msg;

  String get disable_extra_charge_msg;

  String get stripe;

  String get razorpay;

  String get pay_stack;

  String get flutter_wave;

  String get ssl_commerz;

  String get paypal;

  String get paytabs;

  String get mercado_pago;

  String get paytm;

  String get my_fatoorah;

  String get store_id;

  String get store_password;

  String get tokenization_key;

  String get access_token;

  String get profile_id;

  String get server_key;

  String get client_key;

  String get mId;

  String get merchant_key;

  String get token;

  String get order_summury;

  String get crete_order;

  String get pickup_current_validation_msg;

  String get pickup_deliver_validation_msg;

  String get deliver_now;

  String get schedule;

  String get pick_time;

  String get end_start_time_validation_msg;

  String get from;

  String get to;

  String get deliver_time;

  String get date;

  String get number_of_parcels;

  String get pickup_info;

  String get pickup_location;

  String get pickup_contact_number;

  String get contact_length_validation;

  String get pickup_description;

  String get delivery_information;

  String get delivery_location;

  String get delivery_contact_number;

  String get delivery_description;

  String get pending;

  String get paid;

  String get on_pickup;

  String get on_delivery;

  String get create_order;

  String get parcelDetails;

  String get paymentDetails;

  String get note;

  String get courierWillPickupAt;

  String get courierWillDeliveredAt;

  String get go;

  String get pleaseEnterOrderId;

  String get indicatesAutoAssignOrder;

  String get appSetting;

  String get orderHistory;

  String get aboutUser;

  String get aboutDeliveryMan;

  String get please_select_distance_unit;

  String get firebase;

  String get for_admin;

  String get order_auto_assign;

  String get distance;

  String get distance_unit;

  String get pleaseSelectValidAddress;

  String get selectedAddressValidation;

  String get updateDocument;

  String get pressBackAgainToExit;

  String get previous;

  String get next;

  String get createOrderQue;

  String get createOrderConfirmation;

  String get language;

  String get light;

  String get dark;

  String get systemDefault;

  String get emailValidation;

  String get passwordValidation;

  String get rememberMe;

  String get forgotPassword;

  String get all;

  String get assignOrderConfirmationMsg;

  String get transferOrderConfirmationMsg;

  String get submit;

  String get editProfile;

  String get changePassword;

  String get profile;

  String get oldPassword;

  String get newPassword;

  String get confirmPassword;

  String get passwordNotMatch;

  String get profileUpdatedSuccessfully;

  String get youCannotChangeEmailId;

  String get username;

  String get youCannotChangeUsername;

  String get address;

  String get contactNumber;

  String get weeklyPaymentReport;

  String get otpVerificationOnPickupDelivery;

  String get currencySetting;

  String get currencyPosition;

  String get currencySymbol;

  String get pick;

  String get perPage;
}
