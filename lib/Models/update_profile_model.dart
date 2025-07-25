class UpdateProfile {
  bool? success;
  String? message;
  String? token;
  Customer? customer;
  bool? needsAddress;

  UpdateProfile(
      {this.success,
        this.message,
        this.token,
        this.customer,
        this.needsAddress});

  UpdateProfile.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    token = json['token'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    needsAddress = json['needs_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['token'] = this.token;
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    data['needs_address'] = this.needsAddress;
    return data;
  }
}

class Customer {
  int? id;
  String? firstName;
  String? lastName;
  String? mobile;
  String? email;
  String? gender;
  Null? otpVerifiedAt;
  Null? deviceType;
  String? status;
  Null? lastLoginAt;
  String? createdAt;
  String? updatedAt;

  Customer(
      {this.id,
        this.firstName,
        this.lastName,
        this.mobile,
        this.email,
        this.gender,
        this.otpVerifiedAt,
        this.deviceType,
        this.status,
        this.lastLoginAt,
        this.createdAt,
        this.updatedAt});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    mobile = json['mobile'];
    email = json['email'];
    gender = json['gender'];
    otpVerifiedAt = json['otp_verified_at'];
    deviceType = json['device_type'];
    status = json['status'];
    lastLoginAt = json['last_login_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['otp_verified_at'] = this.otpVerifiedAt;
    data['device_type'] = this.deviceType;
    data['status'] = this.status;
    data['last_login_at'] = this.lastLoginAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
