class SendOtpModel {
  bool? success;
  String? message;
  String? oTP;
  dynamic smsData; // Changed from SmsData? to dynamic

  SendOtpModel({this.success, this.message, this.oTP, this.smsData});

  SendOtpModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    oTP = json['OTP'];
    smsData = json['sms_data']; // Handle as dynamic
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = this.success;
    data['message'] = this.message;
    data['OTP'] = this.oTP;
    if (this.smsData != null) {
      data['sms_data'] = this.smsData;
    }
    return data;
  }
}