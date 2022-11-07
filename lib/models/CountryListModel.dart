import 'package:local_delivery_admin/models/PaginationModel.dart';

class CountryListModel {
  PaginationModel? pagination;
  List<CountryData>? data;

  CountryListModel({this.pagination, this.data});

  CountryListModel.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new PaginationModel.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <CountryData>[];
      json['data'].forEach((v) {
        data!.add(new CountryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CountryData {
  int? id;
  String? name;
  String? distanceType;
  String? weightType;
  int? status;
  var links;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? code;

  CountryData(
      {this.id,
        this.name,
        this.distanceType,
        this.weightType,
        this.status,
        this.links,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,this.code});

  CountryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    distanceType = json['distance_type'];
    weightType = json['weight_type'];
    status = json['status'];
    links = json['links'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['distance_type'] = this.distanceType;
    data['weight_type'] = this.weightType;
    data['status'] = this.status;
    data['links'] = this.links;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['code'] = this.code;
    return data;
  }
}

