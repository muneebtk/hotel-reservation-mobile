class SearchHotelCityNameModel {
  final String hotelName;
  final String cityName;
  final String checkingDate;
  final String checkoutDate;
  final int members;
  final int room;
  final double? lat;
  final double? lng;
  final String sorted;
  final Map<String, dynamic> filter;
  final List<double> priceRangeSort;

  SearchHotelCityNameModel({
    required this.hotelName,
    required this.sorted,
    required this.cityName,
    required this.checkingDate,
    required this.checkoutDate,
    required this.members,
    required this.room,
    required this.filter,
    required this.priceRangeSort,
     this.lat,
     this.lng,
  });

  Map<String, dynamic> toJson() {
    return {
      "sorted": sorted,
      "city_name": cityName,
      "hotel_name": hotelName,
      "checkin_date": checkingDate,
      "checkout_date": checkoutDate,
      "members": members,
      "room": room,
      "filter": filter,
      "priceRange": priceRangeSort,
      if(lat != null)
      "latitude": lat,
      if(lng!= null)
      "longitude": lng,
    };
  }
}
