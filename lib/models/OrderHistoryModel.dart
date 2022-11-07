class OrderHistoryModel {
  String? created_at;
  String? datetime;
  String? deleted_at;
  HistoryData? history_data;
  String? history_message;
  String? history_type;
  int? id;
  int? order_id;
  String? updated_at;

  OrderHistoryModel({
    this.created_at,
    this.datetime,
    this.deleted_at,
    this.history_data,
    this.history_message,
    this.history_type,
    this.id,
    this.order_id,
    this.updated_at,
  });

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) {
    return OrderHistoryModel(
      created_at: json['created_at'],
      datetime: json['datetime'],
      deleted_at: json['deleted_at'],
      history_data: json['history_data'] != null ? HistoryData.fromJson(json['history_data']) : null,
      history_message: json['history_message'],
      history_type: json['history_type'],
      id: json['id'],
      order_id: json['order_id'],
      updated_at: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.created_at;
    data['datetime'] = this.datetime;
    data['deleted_at'] = this.deleted_at;
    data['history_message'] = this.history_message;
    data['history_type'] = this.history_type;
    data['id'] = this.id;
    data['order_id'] = this.order_id;
    data['updated_at'] = this.updated_at;
    if (this.history_data != null) {
      data['history_data'] = this.history_data!.toJson();
    }
    return data;
  }
}

class HistoryData {
  var clientId;
  String? clientName;
  var deliveryManId;
  String? deliveryManName;
  var orderId;
  String? paymentStatus;

  HistoryData({this.clientId, this.clientName, this.deliveryManName});

  HistoryData.fromJson(Map<String, dynamic> json) {
    clientId = json['client_id'];
    clientName = json['client_name'];
    deliveryManId = json['delivery_man_id'];
    deliveryManName = json['delivery_man_name'];
    orderId = json['order_id'];
    paymentStatus = json['payment_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['client_id'] = this.clientId;
    data['client_name'] = this.clientName;
    data['delivery_man_id'] = this.deliveryManId;
    data['delivery_man_name'] = this.deliveryManName;
    data['order_id'] = this.orderId;
    data['payment_status'] = this.paymentStatus;
    return data;
  }
}
