class AddAddress {
  final bool success;
  final String? message;
  final String? token;
  final Customer? customer;
  final Address? address;
  final bool? registrationComplete;

  AddAddress({
    required this.success,
    this.message,
    this.token,
    this.customer,
    this.address,
    this.registrationComplete,
  });

  factory AddAddress.fromJson(Map<String, dynamic> json) {
    return AddAddress(
      success: json['success'] ?? false,
      message: json['message'],
      token: json['token'],
      customer: json['customer'] != null ? Customer.fromJson(json['customer']) : null,
      address: json['address'] != null ? Address.fromJson(json['address']) : null,
      registrationComplete: json['registration_complete'],
    );
  }
}

class Customer {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? mobile;
  final String? email;
  final String? gender;
  final String? otpVerifiedAt;
  final String? deviceType;
  final String? status;
  final String? lastLoginAt;
  final String? createdAt;
  final String? updatedAt;
  final List<Addresses>? addresses;

  Customer({
    this.id,
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
    this.updatedAt,
    this.addresses,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      mobile: json['mobile'],
      email: json['email'],
      gender: json['gender'],
      otpVerifiedAt: json['otp_verified_at'],
      deviceType: json['device_type'],
      status: json['status'],
      lastLoginAt: json['last_login_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      addresses: json['addresses'] != null
          ? (json['addresses'] as List).map((e) => Addresses.fromJson(e)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'mobile': mobile,
      'email': email,
      'gender': gender,
      'otp_verified_at': otpVerifiedAt,
      'device_type': deviceType,
      'status': status,
      'last_login_at': lastLoginAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'addresses': addresses?.map((e) => e.toJson()).toList(),
    };
  }
}

class Addresses {
  final int? id;
  final String? customerId;
  final String? addressType;
  final String? address;
  final double? latitude;
  final double? longitude;
  final bool? isDefault;
  final String? createdAt;
  final String? updatedAt;

  Addresses({
    this.id,
    this.customerId,
    this.addressType,
    this.address,
    this.latitude,
    this.longitude,
    this.isDefault,
    this.createdAt,
    this.updatedAt,
  });

  factory Addresses.fromJson(Map<String, dynamic> json) {
    return Addresses(
      id: json['id'],
      customerId: json['customer_id'].toString(),
      addressType: json['address_type'],
      address: json['address'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      isDefault: json['is_default'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'address_type': addressType,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'is_default': isDefault,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class Address {
  final int? customerId;
  final String? addressType;
  final String? address;
  final double? latitude;
  final double? longitude;
  final bool? isDefault;
  final String? createdAt;
  final String? updatedAt;
  final int? id;

  Address({
    this.customerId,
    this.addressType,
    this.address,
    this.latitude,
    this.longitude,
    this.isDefault,
    this.createdAt,
    this.updatedAt,
    this.id,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      customerId: json['customer_id'],
      addressType: json['address_type'],
      address: json['address'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      isDefault: json['is_default'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      id: json['id'],
    );
  }
}