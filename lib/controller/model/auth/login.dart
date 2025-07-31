class LoginUserModel {
  final String? email;
  final String? passsword;
  final String? platform;
  final String? fcmToken;
  final String? deviceName;

  LoginUserModel(
      {required this.email,
      required this.passsword,
      required this.platform,
      required this.fcmToken,
      this.deviceName,
      });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': passsword,
      'platform': platform,
      'fcmToken': fcmToken,
      'device_name': deviceName,
    };
  }
}

class LoginToken {
  final String accessToken;
  final String refreshToken;

  LoginToken({required this.accessToken, required this.refreshToken});

  factory LoginToken.fromJson(Map<String, dynamic> json) {
    return LoginToken(
        accessToken: json['access'], refreshToken: json['refresh']);
  }
}
