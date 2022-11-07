class DeliveryPointModel {
  String? address;
  String? contact_number;
  String? start_time;
  String? description;
  String? latitude;
  String? longitude;

  DeliveryPointModel({
    this.address,
    this.contact_number,
    this.start_time,
    this.description,
    this.latitude,
    this.longitude,
  });

  factory DeliveryPointModel.fromJson(Map<String, dynamic> json) {
    return DeliveryPointModel(
      address: json['address'],
      contact_number: json['contact_number'],
      start_time: json['start_time'],
      description: json['description'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['contact_number'] = this.contact_number;
    data['start_time'] = this.start_time;
    data['description'] = this.description;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
