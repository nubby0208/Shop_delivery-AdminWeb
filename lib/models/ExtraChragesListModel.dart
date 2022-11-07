import 'PaginationModel.dart';

class ExtraChargesListModel {
  PaginationModel? pagination;
  List<ExtraChargesData>? data;

  ExtraChargesListModel({this.pagination, this.data});

  ExtraChargesListModel.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new PaginationModel.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <ExtraChargesData>[];
      json['data'].forEach((v) {
        data!.add(new ExtraChargesData.fromJson(v));
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

class ExtraChargesData {
  int? id;
  String? title;
  String? chargesType;
  double? charges;
  int? countryId;
  String? countryName;
  int? cityId;
  String? cityName;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  ExtraChargesData(
      {this.id,
        this.title,
        this.chargesType,
        this.charges,
        this.countryId,
        this.countryName,
        this.cityId,
        this.cityName,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  ExtraChargesData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    chargesType = json['charges_type'];
    charges = json['charges'];
    countryId = json['country_id'];
    countryName = json['country_name'];
    cityId = json['city_id'];
    cityName = json['city_name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['charges_type'] = this.chargesType;
    data['charges'] = this.charges;
    data['country_id'] = this.countryId;
    data['country_name'] = this.countryName;
    data['city_id'] = this.cityId;
    data['city_name'] = this.cityName;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}