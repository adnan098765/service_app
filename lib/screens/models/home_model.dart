class HomeModel {
  bool? success;
  Data? data;

  HomeModel({this.success, this.data});

  HomeModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Banners>? banners;
  List<FeaturedCategories>? featuredCategories;

  Data({this.banners, this.featuredCategories});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['banners'] != null) {
      banners = <Banners>[];
      json['banners'].forEach((v) {
        banners!.add(new Banners.fromJson(v));
      });
    }
    if (json['featured_categories'] != null) {
      featuredCategories = <FeaturedCategories>[];
      json['featured_categories'].forEach((v) {
        featuredCategories!.add(new FeaturedCategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.banners != null) {
      data['banners'] = this.banners!.map((v) => v.toJson()).toList();
    }
    if (this.featuredCategories != null) {
      data['featured_categories'] =
          this.featuredCategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Banners {
  int? id;
  String? name;
  Null? title;
  Null? description;
  String? imageUrl;
  Null? linkUrl;
  int? sortOrder;

  Banners(
      {this.id,
        this.name,
        this.title,
        this.description,
        this.imageUrl,
        this.linkUrl,
        this.sortOrder});

  Banners.fromJson(Map<String, dynamic> json) {
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

class FeaturedCategories {
  int? id;
  String? categoryName;
  String? image;
  int? servicesCount;

  FeaturedCategories(
      {this.id, this.categoryName, this.image, this.servicesCount});

  FeaturedCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    image = json['image'];
    servicesCount = json['services_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    data['image'] = this.image;
    data['services_count'] = this.servicesCount;
    return data;
  }
}
