import 'package:local_delivery_admin/models/OrderModel.dart';
import 'package:local_delivery_admin/models/PaginationModel.dart';

class OrderListModel {
  PaginationModel? pagination;
  List<OrderModel>? data;
  int? allUnreadCount;

  OrderListModel({this.pagination, this.data, this.allUnreadCount});

  OrderListModel.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null ? new PaginationModel.fromJson(json['pagination']) : null;
    if (json['data'] != null) {
      data = <OrderModel>[];
      json['data'].forEach((v) {
        data!.add(new OrderModel.fromJson(v));
      });
    }
    allUnreadCount = json['all_unread_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['all_unread_count'] = this.allUnreadCount;
    return data;
  }
}


