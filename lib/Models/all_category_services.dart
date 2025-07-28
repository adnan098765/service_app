
class AllCategoryServices {
  bool? success;
  Data? data;

  AllCategoryServices({this.success, this.data});

  AllCategoryServices.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? false;
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Category>? categories;
  List<Services>? services;
  int? totalServices;

  Data({this.categories, this.services, this.totalServices});

  Data.fromJson(Map<String, dynamic> json) {
    // Handle both 'categories' and 'category' fields
    if (json['categories'] != null && json['categories'] is List) {
      categories = (json['categories'] as List)
          .map((e) => Category.fromJson(e))
          .toList();
    } else if (json['category'] != null && json['category'] is Map) {
      categories = [Category.fromJson(json['category'])];
    } else {
      categories = [];
    }
    if (json['services'] != null && json['services'] is List) {
      services = (json['services'] as List)
          .map((v) => Services.fromJson(v))
          .toList();
    } else {
      services = [];
    }
    totalServices = json['total_services'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (categories != null) {
      data['categories'] = categories!.map((e) => e.toJson()).toList();
    }
    if (services != null) {
      data['services'] = services!.map((v) => v.toJson()).toList();
    }
    data['total_services'] = totalServices;
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
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['category_name'] = categoryName;
    data['image'] = image;
    return data;
  }
}

class Services {
  int? id;
  String? serviceName;
  String? description;
  String? regularPrice;
  String? salePrice;
  String? image;
  bool? isFeatured;
  Category? category;

  Services({
    this.id,
    this.serviceName,
    this.description,
    this.regularPrice,
    this.salePrice,
    this.image,
    this.isFeatured,
    this.category,
  });

  Services.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceName = json['service_name'];
    description = json['description'];
    regularPrice = json['regular_price']?.toString();
    salePrice = json['sale_price']?.toString();
    image = json['image'];
    isFeatured = json['is_featured'];
    category = json['category'] != null
        ? Category.fromJson(json['category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['service_name'] = serviceName;
    data['description'] = description;
    data['regular_price'] = regularPrice;
    data['sale_price'] = salePrice;
    data['image'] = image;
    data['is_featured'] = isFeatured;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    return data;
  }
}