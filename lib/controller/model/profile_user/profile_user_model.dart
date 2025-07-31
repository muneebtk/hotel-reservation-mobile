import 'dart:core';

class ProfileUserModel {
  final String firstname;
  final String lastname;
  final String? profilepic;
  final String dateofbirth;
  final String gender;
  final String email;
  final String? contactNumber;
  final String? dialCode;
  final String? countryCode;

  ProfileUserModel({
    required this.firstname,
    required this.lastname,
    this.profilepic,
    required this.dateofbirth,
    required this.gender,
    required this.email,
    required this.contactNumber,
    this.dialCode,
    this.countryCode,
  });

  factory ProfileUserModel.fromJson(Map<String, dynamic> json) {
    return ProfileUserModel(
        firstname: json['first_name'] ?? "",
        lastname: json['last_name'] ?? "",
        profilepic: json['image'] ?? "",
        dateofbirth: json['dob'] ?? "",
        gender: json['gender'] ?? "",
        email: json['email'] ?? "",
        countryCode: json['iso_code'] ?? "",
        dialCode: json['dial_code'] ?? "",
        contactNumber: json['contact_number']);
  }

  Map<String, dynamic> toJson() {
    return {
      //'id': id,
      'first_name': firstname,
      'last_name': lastname,
      'image': profilepic,
      'dob': dateofbirth,
      'gender': gender,
      'email': email,
      'contact_number': contactNumber,
      'dial_code': dialCode,
      'iso_code': countryCode,
    };
  }
}
//-------------------------------------------------------------------------------------------

class ProfileUserModel2 {
  //final int id;
  final String firstname;
  final String lastname;
  final String dateofbirth;
  final String gender;
  final String email;
  final String contactNumber;
  final String dialCode;
  final String countryCode;

  ProfileUserModel2({
    required this.firstname,
    required this.lastname,
    required this.dateofbirth,
    required this.gender,
    required this.email,
    required this.dialCode,
    required this.contactNumber,
    required this.countryCode,
  });
}
