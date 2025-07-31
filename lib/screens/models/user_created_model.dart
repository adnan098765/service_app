class CreateUserModel {
  bool? success;
  String? customerType;
  String? message;
  int? customerId;
  bool? isProfileComplete;
  dynamic customerData;
  String? token; // Add this

  CreateUserModel({
    this.success,
    this.customerType,
    this.message,
    this.customerId,
    this.isProfileComplete,
    this.customerData,
    this.token, // Add this
  });

  CreateUserModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    customerType = json['customer_type'];
    message = json['message'];
    customerId = json['customer_id'];
    isProfileComplete = json['is_profile_complete'];
    customerData = json['customer_data'];
    token = json['token']; // Add this
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['customer_type'] = customerType;
    data['message'] = message;
    data['customer_id'] = customerId;
    data['is_profile_complete'] = isProfileComplete;
    data['customer_data'] = customerData;
    data['token'] = token;
    return data;
  }
}