import 'package:local_delivery_admin/models/OrderModel.dart';

import 'OrderHistoryModel.dart';

class OrderDetailModel {
  OrderModel? data;
  List<OrderHistoryModel>? orderHistory;

  OrderDetailModel({this.data, this.orderHistory});

  OrderDetailModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new OrderModel.fromJson(json['data']) : null;
    if (json['order_history'] != null) {
      orderHistory = <OrderHistoryModel>[];
      json['order_history'].forEach((v) {
        orderHistory!.add(new OrderHistoryModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.orderHistory != null) {
      data['order_history'] = this.orderHistory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
