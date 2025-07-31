class BookingData {
  final int id;
  final String bookingFname;
  final String bookingLname;
  final String bookingEmail;
  final String bookingMobileNumber;
  final String checkinDate;
  final String checkoutDate;
  final String discountPrice;
  final String serviceFee;
  final String bookedPrice;
  final int numberOfGuests;
  final int numberOfBookingRooms;
  final bool isMySelf;
  final String bookingId;
  final String bookingDate;
  final String createdDate;
  final String modifiedDate;
  final String status;
  final String qrcode;
  final dynamic transaction;
  final int user;
  final int chalet;

  BookingData({
    required this.qrcode,
    required this.id,
    required this.bookingFname,
    required this.bookingLname,
    required this.bookingEmail,
    required this.bookingMobileNumber,
    required this.checkinDate,
    required this.checkoutDate,
    required this.discountPrice,
    required this.serviceFee,
    required this.bookedPrice,
    required this.numberOfGuests,
    required this.numberOfBookingRooms,
    required this.isMySelf,
    required this.bookingId,
    required this.bookingDate,
    required this.createdDate,
    required this.modifiedDate,
    required this.status,
    this.transaction,
    required this.user,
    required this.chalet,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
      qrcode: json['qr_code_url'],
      id: json['id'],
      bookingFname: json['booking_fname'],
      bookingLname: json['booking_lname'],
      bookingEmail: json['booking_email'],
      bookingMobileNumber: json['booking_mobilenumber'],
      checkinDate: json['checkin_date'],
      checkoutDate: json['checkout_date'],
      discountPrice: json['discount_price'],
      serviceFee: json['service_fee'],
      bookedPrice: json['booked_price'],
      numberOfGuests: json['number_of_guests'],
      numberOfBookingRooms: json['number_of_booking_rooms'],
      isMySelf: json['is_my_self'],
      bookingId: json['booking_id'],
      bookingDate: json['booking_date'],
      createdDate: json['created_date'],
      modifiedDate: json['modified_date'],
      status: json['status'],
      transaction: json['transaction'] ?? "null",
      user: json['user'],
      chalet: json['chalet'],
    );
  }
}

class BookingData2 {
  final int id;
  final String bookingFname;
  final String bookingLname;
  final String bookingEmail;
  final String bookingMobileNumber;
  final String checkinDate;
  final String checkoutDate;
  final double discountPrice;
  final double serviceFee;
  final double bookedPrice;
  final int adults;
  final int children;
  final int numberOfGuests;
  final int numberOfBookingRooms;
  final bool isMySelf;
  final String paymentType;
  final String discountPercentage;
  final String promocodeApplied;
  double? taxAndServices;

  BookingData2({
    required this.id,
    required this.bookingFname,
    required this.bookingLname,
    required this.bookingEmail,
    required this.bookingMobileNumber,
    required this.checkinDate,
    required this.checkoutDate,
    required this.discountPrice,
    required this.serviceFee,
    required this.bookedPrice,
    required this.numberOfGuests,
    required this.adults,
    required this.children,
    required this.numberOfBookingRooms,
    required this.isMySelf,
    required this.paymentType,
    required this.discountPercentage,
    required this.promocodeApplied,
    required this.taxAndServices,
  });

  Map<String, dynamic> toJson() {
    return {
      'chalet': id,
      'booking_fname': bookingFname,
      'booking_lname': bookingLname,
      'booking_email': bookingEmail,
      'booking_mobilenumber': bookingMobileNumber,
      'checkin_date': checkinDate,
      'checkout_date': checkoutDate,
      'discount_price': discountPrice,
      'service_fee': serviceFee,
      'booked_price': bookedPrice,
      'number_of_guests': numberOfGuests,
      'adults': adults,
      'children': children,
      'number_of_booking_rooms': numberOfBookingRooms,
      'is_my_self': isMySelf,
      'payment_type': paymentType,
      'promocode_applied': promocodeApplied,
      'discount_percentage_applied': discountPercentage,
      "tax_and_services": taxAndServices?.toStringAsFixed(3),
    };
  }
}
