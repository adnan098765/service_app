class GetCategoriesWithFeaturedModel {
  bool? success;
  Data? data;

  GetCategoriesWithFeaturedModel({this.success, this.data});

  GetCategoriesWithFeaturedModel.fromJson(Map<String, dynamic> json) {
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
  List<Categories>? categories;
  List<FeaturedServices>? featuredServices;

  Data({this.categories, this.featuredServices});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
    if (json['featured_services'] != null) {
      featuredServices = <FeaturedServices>[];
      json['featured_services'].forEach((v) {
        featuredServices!.add(new FeaturedServices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    if (this.featuredServices != null) {
      data['featured_services'] =
          this.featuredServices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  int? id;
  String? categoryName;
  String? image;
  bool? isFeatured;
  int? servicesCount;

  Categories(
      {this.id,
        this.categoryName,
        this.image,
        this.isFeatured,
        this.servicesCount});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    image = json['image'];
    isFeatured = json['is_featured'];
    servicesCount = json['services_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    data['image'] = this.image;
    data['is_featured'] = this.isFeatured;
    data['services_count'] = this.servicesCount;
    return data;
  }
}

class FeaturedServices {
  int? id;
  String? serviceName;
  String? description;
  String? regularPrice;
  String? salePrice;
  String? image;
  bool? isFeatured;
  Category? category;

  FeaturedServices(
      {this.id,
        this.serviceName,
        this.description,
        this.regularPrice,
        this.salePrice,
        this.image,
        this.isFeatured,
        this.category});

  FeaturedServices.fromJson(Map<String, dynamic> json) {
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

class Category {
  int? id;
  String? categoryName;

  Category({this.id, this.categoryName});

  Category.fromJson(Map<String, dynamic> json) {
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
