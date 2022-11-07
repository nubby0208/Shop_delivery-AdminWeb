import 'package:local_delivery_admin/models/UserModel.dart';

class UpdateUserStatus {
  UserModel? data;
  String? message;

  UpdateUserStatus({this.data, this.message});

  factory UpdateUserStatus.fromJson(Map<String, dynamic> json) {
    return UpdateUserStatus(
      data: json['data'] != null ? UserModel.fromJson(json['data']) : null,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
