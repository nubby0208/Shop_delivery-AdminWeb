class PickupPointModel {
  String? address;
  String? latitude;
  String? longitude;
  String? description;
  String? contactNumber;
  String? startTime;
  String? endTime;

  PickupPointModel({this.address, this.latitude, this.longitude, this.description, this.contactNumber, this.startTime, this.endTime});

  PickupPointModel.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    description = json['description'];
    contactNumber = json['contact_number'];
    startTime = json['start_time'];
    endTime = json['end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['description'] = this.description;
    data['contact_number'] = this.contactNumber;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    return data;
  }
}
