class AllCategoryServices {
  bool? success;
  Data? data;

  AllCategoryServices({this.success, this.data});

  AllCategoryServices.fromJson(Map<String, dynamic> json) {
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
  Category? category;
  List<Services>? services;
  int? totalServices;

  Data({this.category, this.services, this.totalServices});

  Data.fromJson(Map<String, dynamic> json) {
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(new Services.fromJson(v));
      });
    }
    totalServices = json['total_services'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.services != null) {
      data['services'] = this.services!.map((v) => v.toJson()).toList();
    }
    data['total_services'] = this.totalServices;
    return data;
  }
}

class Category {
  int? id;
  String? categoryName;
  String? image;

  Category({this.id, this.categoryName, this.image});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    data['image'] = this.image;
    return data;
  }
}

class Services {
  int? id;
  String? serviceName;
  String? description;
  String? regularPrice;
  Null? salePrice;
  String? image;
  bool? isFeatured;
  Category? category;

  Services(
      {this.id,
        this.serviceName,
        this.description,
        this.regularPrice,
        this.salePrice,
        this.image,
        this.isFeatured,
        this.category});

  Services.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceName = json['service_name'];
    description = json['description'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    image = json['image'];
    isFeatured = json['is_featured'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['service_name'] = this.serviceName;
    data['description'] = this.description;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    data['image'] = this.image;
    data['is_featured'] = this.isFeatured;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    return data;
  }
}

class Category1 {
  int? id;
  String? categoryName;

  Category1({this.id, this.categoryName});

  Category1.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    return data;
  }
}
