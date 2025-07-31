import 'package:e_concierge_tourism/controller/model/profile_page/image_picker.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

class ImagePickerController extends GetxController {
  late Database _db;
  var profileImageSelection = <UserProfileImage>[].obs;

  @override
  void onInit() {
    super.onInit();
    initDatabase();
  }

  Future<void> initDatabase() async {
    _db = await openDatabase('image.db', version: 1,
        onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE image (id INTEGER PRIMARY KEY, imagePath TEXT)');
    });
    await getImage();
  }

  Future<void> addImage(UserProfileImage value) async {
    await _db.insert(
      'image',
      value.toMap(),
    );

    await getImage();
  }

  Future<void> getImage() async {
    final List<Map<String, dynamic>> imageMap = await _db.query('image');
    final data = imageMap.map((e) => UserProfileImage.fromMap(e)).toList();

    profileImageSelection.assignAll(data);
    update();
  }
}
