class PaginationModel {
  int? currentPage;
  var per_page;
  int? totalPages;
  int? total_items;

  PaginationModel({this.currentPage, this.per_page, this.totalPages, this.total_items});

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      currentPage: json['currentPage'],
      per_page: json['per_page'],
      totalPages: json['totalPages'],
      total_items: json['total_items'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currentPage'] = this.currentPage;
    data['per_page'] = this.per_page;
    data['totalPages'] = this.totalPages;
    data['total_items'] = this.total_items;
    return data;
  }
}
