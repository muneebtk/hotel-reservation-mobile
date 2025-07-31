class UserProfileImage {
  int? id;
  String? imagePath;

  UserProfileImage({this.id, this.imagePath});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imagePath': imagePath,
    };
  }

  factory UserProfileImage.fromMap(Map<String, dynamic> map) {
    return UserProfileImage(
      id: map['id'],
      imagePath: map['imagePath'],
    );
  }
}
