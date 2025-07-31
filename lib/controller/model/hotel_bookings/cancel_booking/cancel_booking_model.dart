class BookingCancellationModel {
  final int hotelId;
  final String reason;
  final String bookingid;

  BookingCancellationModel(
      {required this.hotelId, required this.reason, required this.bookingid});

  factory BookingCancellationModel.fromJson(Map<String, dynamic> json) {
    return BookingCancellationModel(
        hotelId: json['hotelid'] as int,
        reason: json['reason'] as String,
        bookingid: json['booking_id']);
  }

  Map<String, dynamic> toJson() {
    return {'hotelid': hotelId, 'reason': reason, 'booking_id': bookingid};
  }
}

//*==========CHALET===============================
class BookingCancellationCHALETModel {
  final String reason;
  final String bookingid;

  BookingCancellationCHALETModel(
      {required this.reason, required this.bookingid});

  factory BookingCancellationCHALETModel.fromJson(Map<String, dynamic> json) {
    return BookingCancellationCHALETModel(
        reason: json['reason'] as String, bookingid: json['booking_id']);
  }

  Map<String, dynamic> toJson() {
    return {'reason': reason, 'booking_id': bookingid};
  }
}
