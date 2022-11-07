import 'package:local_delivery_admin/models/UserModel.dart';
import 'package:local_delivery_admin/models/PaginationModel.dart';

class UserListModel {
  List<UserModel>? data;
  PaginationModel? pagination;

  UserListModel({this.data, this.pagination});

  factory UserListModel.fromJson(Map<String, dynamic> json) {
    return UserListModel(
      data: json['data'] != null ? (json['data'] as List).map((i) => UserModel.fromJson(i)).toList() : null,
      pagination: json['pagination'] != null ? PaginationModel.fromJson(json['pagination']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}
