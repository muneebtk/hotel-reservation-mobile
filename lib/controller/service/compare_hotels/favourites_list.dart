import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

class FavouritesChaletsModel {
  final int? id;
  final String? rating;
  final String? rating2;
  final String? price;
  final String? tax;
  final String? offer;
  final String? chaletImage;
  final String? chalatName;
  final String? address;
  final String? userId;
  // final List<String>? roomTypes;

  FavouritesChaletsModel({
    this.id,
    required this.rating,
    required this.rating2,
    required this.price,
    required this.tax,
    required this.offer,
    required this.chaletImage,
    required this.chalatName,
    required this.address,
    required this.userId,
  });

  factory FavouritesChaletsModel.fromMap(Map<String, dynamic> map) {
    return FavouritesChaletsModel(
      id: map['id'],
      rating: map['rating'],
      rating2: map['rating2'],
      price: map['price'],
      tax: map['tax'],
      offer: map['offer'],
      chaletImage: map['chaletImage'],
      chalatName: map['chalatName'],
      address: map['address'],
      userId: map['userId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'rating': rating,
      'rating2': rating2,
      'price': price,
      'tax': tax,
      'offer': offer,
      'chaletImage': chaletImage,
      'chalatName': chalatName,
      'address': address,
      "userId": userId,
    };
  }
}

class FavouritesService extends GetxController {
  RxList<FavouritesChaletsModel> favouriteChaletList =
      <FavouritesChaletsModel>[].obs;
  late Database _db;

  @override
  void onInit() {
    super.onInit();
    initDatabase();
  }

  Future<void> initDatabase() async {
    _db = await openDatabase('favouriteChalet.db', version: 1,
        onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE favourites (id INTEGER PRIMARY KEY, chalatName TEXT, price TEXT, tax TEXT, chaletImage TEXT, address TEXT, offer TEXT, rating TEXT, rating2 TEXT, userId TEXT)');
    });
    await getAllfavouritesChaletList();
  }

  Future<void> addedToFavourites(FavouritesChaletsModel value) async {
    bool isAlreadyInFavorites = await isItemInFavorites(value);
    if (!isAlreadyInFavorites) {
      await _db.rawInsert(
          "INSERT INTO favourites (chalatName, price, tax, chaletImage, address, offer, rating, rating2, userId) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
          [
            value.chalatName,
            value.price,
            value.tax,
            value.chaletImage,
            value.address,
            value.offer,
            value.rating,
            value.rating2,
            value.userId,

            //)
          ]);

      await getAllfavouritesChaletList();
    } else {}
  }

  Future<void> getAllfavouritesChaletList() async {
    final List<Map<String, dynamic>> favouriteChaletMap =
        await _db.rawQuery("SELECT * FROM favourites");
    final data = favouriteChaletMap
        .map((e) => FavouritesChaletsModel.fromMap(e))
        .toList();

    favouriteChaletList.assignAll(data);
    update();
  }

  Future<void> deleteFavouritesItem(FavouritesChaletsModel item) async {
    await _db.rawDelete('DELETE FROM favourites WHERE id = ?', [item.id]);
    favouriteChaletList.remove(item);
    update();
  }

  Future<void> deleteFavouritesItemAll() async {
    await _db.rawDelete('DELETE FROM favourites');
    favouriteChaletList.clear();
    update();
  }

  Future<bool> isItemInFavorites(FavouritesChaletsModel item) async {
    final List<Map<String, dynamic>> result = await _db.rawQuery(
        'SELECT * FROM favourites WHERE chalatName = ?', [item.chalatName]);
    return result.isNotEmpty;
  }

  bool isItemInFavoritesSync(String chalatName) {
    return favouriteChaletList.any((item) => item.chalatName == chalatName);
  }

  @override
  void onClose() async {
    await _db.close();
    super.onClose();
  }
}
