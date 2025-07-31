class BookingDetailsModel {
  String userName;
  String lastName;
  String email;
  String phoneNumber;
  String hotelName;
  String roomTypes;
  String roomOptions;
  int membersCount;
  int childrenCount;
  double totalAmountIncludingTax;
  String checkinDate;
  String checkoutDate;

  BookingDetailsModel({
    required this.userName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.hotelName,
    required this.roomTypes,
    required this.roomOptions,
    required this.membersCount,
    required this.childrenCount,
    required this.totalAmountIncludingTax,
    required this.checkinDate,
    required this.checkoutDate,
  });

  factory BookingDetailsModel.fromJson(Map<String, dynamic> json) {
    return BookingDetailsModel(
      userName: json['userName'],
      lastName: json['lastName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      hotelName: json['hotelName'],
      roomTypes: json['roomTypes'],
      roomOptions: json['roomOptions'],
      membersCount: json['membersCount'],
      childrenCount: json['childrenCount'],
      totalAmountIncludingTax: json['totalAmountIncludingTax'],
      checkinDate: json['checkinDate'],
      checkoutDate: json['checkoutDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'hotelName': hotelName,
      'roomTypes': roomTypes,
      'roomOptions': roomOptions,
      'membersCount': membersCount,
      'childrenCount': childrenCount,
      'totalAmountIncludingTax': totalAmountIncludingTax,
      'checkinDate': checkinDate,
      'checkoutDate': checkoutDate,
    };
  }
}
