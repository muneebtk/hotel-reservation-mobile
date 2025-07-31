class UserModel {
  final String? firstName;
  final String? lastName;
  final String? contactNum;
  final String? emailId;
  final String? password;
  final String? confirmPassword;
  final String? fcmToken;
  final String? dialCode;
  final String? countryCode;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.contactNum,
    required this.emailId,
    required this.password,
    required this.confirmPassword,
    required this.fcmToken,
    this.dialCode,
    this.countryCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'contact_number': contactNum,
      'email': emailId,
      'password': password,
      'confirm_password': confirmPassword,
      "fcmToken": fcmToken,
      'dial_code': dialCode,
      'iso_code': countryCode,
    };
  }
}
