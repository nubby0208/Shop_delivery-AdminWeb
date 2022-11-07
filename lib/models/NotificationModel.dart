class NotificationModel {
  int? all_unread_count;
  List<NotificationData>? notification_data;

  NotificationModel({this.all_unread_count, this.notification_data});

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      all_unread_count: json['all_unread_count'],
      notification_data: json['notification_data'] != null ? (json['notification_data'] as List).map((i) => NotificationData.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['all_unread_count'] = this.all_unread_count;
    if (this.notification_data != null) {
      data['notification_data'] = this.notification_data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotificationData {
  NotificationOrderData? data;
  String? created_at;
  String? id;
  String? read_at;

  NotificationData({this.data, this.created_at, this.id, this.read_at});

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      data: json['data'] != null ? NotificationOrderData.fromJson(json['data']) : null,
      created_at: json['created_at'],
      id: json['id'],
      read_at: json['read_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.created_at;
    data['id'] = this.id;
    data['read_at'] = this.read_at;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class NotificationOrderData {
  int? id;
  String? message;
  String? subject;
  String? type;

  NotificationOrderData({this.id, this.message, this.subject, this.type});

  factory NotificationOrderData.fromJson(Map<String, dynamic> json) {
    return NotificationOrderData(
      id: json['id'],
      message: json['message'],
      subject: json['subject'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['message'] = this.message;
    data['subject'] = this.subject;
    data['type'] = this.type;
    return data;
  }
}
