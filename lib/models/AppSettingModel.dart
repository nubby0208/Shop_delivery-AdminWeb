class AppSettingModel {
  String? created_at;
  String? facebook_url;
  int? id;
  String? instagram_url;
  String? linkedin_url;
  NotificationSettings? notification_settings;
  String? site_copyright;
  String? site_description;
  String? site_email;
  String? site_name;
  String? support_email;
  String? support_number;
  String? twitter_url;
  String? updated_at;
  int? autoAssign;
  String? distanceUnit;
  num? distance;
  int? otpVerifyOnPickupDelivery;
  String? currency;
  String? currencyCode;
  String? currencyPosition;

  AppSettingModel({
    this.created_at,
    this.facebook_url,
    this.id,
    this.instagram_url,
    this.linkedin_url,
    this.notification_settings,
    this.site_copyright,
    this.site_description,
    this.site_email,
    this.site_name,
    this.support_email,
    this.support_number,
    this.twitter_url,
    this.updated_at,
    this.autoAssign,
    this.distanceUnit,
    this.distance,
    this.otpVerifyOnPickupDelivery,
    this.currency,
    this.currencyCode,
    this.currencyPosition,
  });

  factory AppSettingModel.fromJson(Map<String, dynamic> json) {
    return AppSettingModel(
      created_at: json['created_at'],
      facebook_url: json['facebook_url'] != null ? json['facebook_url'] : "",
      id: json['id'],
      instagram_url: json['instagram_url'] != null ? json['instagram_url'] : "",
      linkedin_url: json['linkedin_url'] != null ? json['linkedin_url'] : "",
      notification_settings: json['notification_settings'] != null ? NotificationSettings.fromJson(json['notification_settings']) : null,
      site_copyright: json['site_copyright'] != null ? json['site_copyright'] : "",
      site_description: json['site_description'] != null ? json['site_description'] : "",
      site_email: json['site_email'] != null ? json['site_email'] : "",
      site_name: json['site_name'] != null ? json['site_name'] : "",
      support_email: json['support_email'] != null ? json['support_email'] : "",
      support_number: json['support_number'] != null ? json['support_number'] : "",
      twitter_url: json['twitter_url'] != null ? json['twitter_url'] : "",
      updated_at: json['updated_at'],
      autoAssign: json['auto_assign'],
      distanceUnit: json['distance_unit'],
      distance: json['distance'],
      otpVerifyOnPickupDelivery: json['otp_verify_on_pickup_delivery'],
      currency: json['currency'],
      currencyCode: json['currency_code'],
      currencyPosition: json['currency_position'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.created_at;
    data['id'] = this.id;
    data['updated_at'] = this.updated_at;
    if (this.facebook_url != null) {
      data['facebook_url'] = this.facebook_url;
    }
    if (this.instagram_url != null) {
      data['instagram_url'] = this.instagram_url;
    }
    if (this.linkedin_url != null) {
      data['linkedin_url'] = this.linkedin_url;
    }
    if (this.notification_settings != null) {
      data['notification_settings'] = this.notification_settings!;
    }
    if (this.site_copyright != null) {
      data['site_copyright'] = this.site_copyright;
    }
    if (this.site_description != null) {
      data['site_description'] = this.site_description;
    }
    if (this.site_email != null) {
      data['site_email'] = this.site_email;
    }
    if (this.site_name != null) {
      data['site_name'] = this.site_name;
    }
    if (this.support_email != null) {
      data['support_email'] = this.support_email;
    }
    if (this.support_number != null) {
      data['support_number'] = this.support_number;
    }
    if (this.twitter_url != null) {
      data['twitter_url'] = this.twitter_url;
    }
    data['auto_assign'] = this.autoAssign;
    data['distance_unit'] = this.distanceUnit;
    data['distance'] = this.distance;
    data['otp_verify_on_pickup_delivery'] = this.otpVerifyOnPickupDelivery;
    data['currency'] = this.currency;
    data['currency_code'] = this.currencyCode;
    data['currency_position'] = this.currencyPosition;
    return data;
  }
}

class NotificationSettings {
  Notifications? active;
  Notifications? cancelled;
  Notifications? completed;
  Notifications? courier_arrived;
  Notifications? courier_assigned;
  Notifications? courier_departed;
  Notifications? courier_picked_up;
  Notifications? courier_transfer;
  Notifications? create;
  Notifications? delayed;
  Notifications? failed;
  Notifications? payment_status_message;

  NotificationSettings(
      {this.active,
      this.cancelled,
      this.completed,
      this.courier_arrived,
      this.courier_assigned,
      this.courier_departed,
      this.courier_picked_up,
      this.courier_transfer,
      this.create,
      this.delayed,
      this.failed,
      this.payment_status_message});

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      active: json['active'] != null ? Notifications.fromJson(json['active']) : null,
      cancelled: json['cancelled'] != null ? Notifications.fromJson(json['cancelled']) : null,
      completed: json['completed'] != null ? Notifications.fromJson(json['completed']) : null,
      courier_arrived: json['courier_arrived'] != null ? Notifications.fromJson(json['courier_arrived']) : null,
      courier_assigned: json['courier_assigned'] != null ? Notifications.fromJson(json['courier_assigned']) : null,
      courier_departed: json['courier_departed'] != null ? Notifications.fromJson(json['courier_departed']) : null,
      courier_picked_up: json['courier_picked_up'] != null ? Notifications.fromJson(json['courier_picked_up']) : null,
      courier_transfer: json['courier_transfer'] != null ? Notifications.fromJson(json['courier_transfer']) : null,
      create: json['create'] != null ? Notifications.fromJson(json['create']) : null,
      delayed: json['delayed'] != null ? Notifications.fromJson(json['delayed']) : null,
      failed: json['failed'] != null ? Notifications.fromJson(json['failed']) : null,
      payment_status_message: json['payment_status_message'] != null ? Notifications.fromJson(json['payment_status_message']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.active != null) {
      data['active'] = this.active!.toJson();
    }
    if (this.cancelled != null) {
      data['cancelled'] = this.cancelled!.toJson();
    }
    if (this.completed != null) {
      data['completed'] = this.completed!.toJson();
    }
    if (this.courier_arrived != null) {
      data['courier_arrived'] = this.courier_arrived!.toJson();
    }
    if (this.courier_assigned != null) {
      data['courier_assigned'] = this.courier_assigned!.toJson();
    }
    if (this.courier_departed != null) {
      data['courier_departed'] = this.courier_departed!.toJson();
    }
    if (this.courier_picked_up != null) {
      data['courier_picked_up'] = this.courier_picked_up!.toJson();
    }
    if (this.courier_transfer != null) {
      data['courier_transfer'] = this.courier_transfer!.toJson();
    }
    if (this.create != null) {
      data['create'] = this.create!.toJson();
    }
    if (this.delayed != null) {
      data['delayed'] = this.delayed!.toJson();
    }
    if (this.failed != null) {
      data['failed'] = this.failed!.toJson();
    }
    if (this.payment_status_message != null) {
      data['payment_status_message'] = this.payment_status_message!.toJson();
    }
    return data;
  }
}

class Notifications {
  String? isOnesignalNotification;
  String? isFirebaseNotification;

  Notifications({this.isOnesignalNotification, this.isFirebaseNotification});

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
      isOnesignalNotification: json['IS_ONESIGNAL_NOTIFICATION'],
      isFirebaseNotification: json['IS_FIREBASE_NOTIFICATION'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IS_ONESIGNAL_NOTIFICATION'] = this.isOnesignalNotification;
    data['IS_FIREBASE_NOTIFICATION'] = this.isFirebaseNotification;
    return data;
  }
}
