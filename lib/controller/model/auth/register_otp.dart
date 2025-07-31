class RegisterOtpModel {
  final int? otp;
  final String? email;
  final String? message;
  final int? storedOtp;

  RegisterOtpModel({this.email, this.otp, this.message, this.storedOtp});

  Map<String, dynamic> toJson() {
    return {'otp': otp, 'stored_email': email, 'stored_otp': storedOtp};
  }

  factory RegisterOtpModel.fromJson(Map<String, dynamic> json) {
    return RegisterOtpModel(
      message: json['message'],
    );
  }
}
