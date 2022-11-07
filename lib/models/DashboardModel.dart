import 'package:local_delivery_admin/models/OrderModel.dart';
import 'package:local_delivery_admin/models/UserModel.dart';

class DashboardModel {
  List<UserModel>? recent_client;
  List<UserModel>? recent_delivery_man;
  List<OrderModel>? recent_order;
  int? today_register_user;
  int? total_city;
  int? total_client;
  int? total_country;
  int? total_delivery_man;
  int? total_order;
  List<OrderModel>? upcoming_order;
  List<WeeklyDataModel>? weekly_order_count;
  List<WeeklyDataModel>? user_weekly_count;
  List<WeeklyDataModel>? weekly_payment_report;
  int? all_unread_count;

  DashboardModel({
    this.recent_client,
    this.recent_delivery_man,
    this.recent_order,
    this.today_register_user,
    this.total_city,
    this.total_client,
    this.total_country,
    this.total_delivery_man,
    this.total_order,
    this.upcoming_order,
    this.weekly_order_count,
    this.user_weekly_count,
    this.all_unread_count,
    this.weekly_payment_report,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      recent_client: json['recent_client'] != null ? (json['recent_client'] as List).map((i) => UserModel.fromJson(i)).toList() : null,
      recent_delivery_man: json['recent_delivery_man'] != null ? (json['recent_delivery_man'] as List).map((i) => UserModel.fromJson(i)).toList() : null,
      recent_order: json['recent_order'] != null ? (json['recent_order'] as List).map((i) => OrderModel.fromJson(i)).toList() : null,
      today_register_user: json['today_register_user'],
      total_city: json['total_city'],
      total_client: json['total_client'],
      total_country: json['total_country'],
      total_delivery_man: json['total_delivery_man'],
      total_order: json['total_order'],
      all_unread_count: json['all_unread_count'],
      upcoming_order: json['upcoming_order'] != null ? (json['upcoming_order'] as List).map((i) => OrderModel.fromJson(i)).toList() : null,
      weekly_order_count: json['weekly_order_count'] != null ? (json['weekly_order_count'] as List).map((i) => WeeklyDataModel.fromJson(i)).toList() : null,
      user_weekly_count: json['user_weekly_count'] != null ? (json['user_weekly_count'] as List).map((i) => WeeklyDataModel.fromJson(i)).toList() : null,
      weekly_payment_report: json['weekly_payment_report'] != null ? (json['weekly_payment_report'] as List).map((i) => WeeklyDataModel.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['today_register_user'] = this.today_register_user;
    data['total_city'] = this.total_city;
    data['total_client'] = this.total_client;
    data['total_country'] = this.total_country;
    data['total_delivery_man'] = this.total_delivery_man;
    data['total_order'] = this.total_order;
    data['all_unread_count'] = this.all_unread_count;
    if (this.recent_client != null) {
      data['recent_client'] = this.recent_client!.map((v) => v.toJson()).toList();
    }
    if (this.recent_delivery_man != null) {
      data['recent_delivery_man'] = this.recent_delivery_man!.map((v) => v.toJson()).toList();
    }
    if (this.recent_order != null) {
      data['recent_order'] = this.recent_order!.map((v) => v.toJson()).toList();
    }
    if (this.upcoming_order != null) {
      data['upcoming_order'] = this.upcoming_order!.map((v) => v.toJson()).toList();
    }
    if (this.weekly_order_count != null) {
      data['weekly_order_count'] = this.weekly_order_count!.map((v) => v.toJson()).toList();
    }
    if (this.user_weekly_count != null) {
      data['user_weekly_count'] = this.user_weekly_count!.map((v) => v.toJson()).toList();
    }
    if (this.weekly_payment_report != null) {
      data['weekly_payment_report'] = this.weekly_payment_report!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WeeklyDataModel {
  String? date;
  String? day;
  int? total;
  num? totalAmount;

  WeeklyDataModel({this.date, this.day, this.total,this.totalAmount});

  factory WeeklyDataModel.fromJson(Map<String, dynamic> json) {
    return WeeklyDataModel(
      date: json['date'],
      day: json['day'],
      total: json['total'],
      totalAmount: json['total_amount']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['day'] = this.day;
    data['total'] = this.total;
    data['total_amount'] = this.totalAmount;
    return data;
  }
}

