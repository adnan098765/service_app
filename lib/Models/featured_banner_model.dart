class FeaturedBannerModel {
  bool? success;
  List<Data>? data;

  FeaturedBannerModel({this.success, this.data});

  FeaturedBannerModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  Null? title;
  Null? description;
  String? imageUrl;
  Null? linkUrl;
  int? sortOrder;

  Data(
      {this.id,
        this.name,
        this.title,
        this.description,
        this.imageUrl,
        this.linkUrl,
        this.sortOrder});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    title = json['title'];
    description = json['description'];
    imageUrl = json['image_url'];
    linkUrl = json['link_url'];
    sortOrder = json['sort_order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['title'] = this.title;
    data['description'] = this.description;
    data['image_url'] = this.imageUrl;
    data['link_url'] = this.linkUrl;
    data['sort_order'] = this.sortOrder;
    return data;
  }
}
