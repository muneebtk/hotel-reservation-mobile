import 'dart:convert';

NotificationResponse notificationResponseFromJson(String str) =>
    NotificationResponse.fromJson(json.decode(str));

String notificationResponseToJson(NotificationResponse data) =>
    json.encode(data.toJson());

class NotificationResponse {
  String? message;
  List<Notifications>? data;

  NotificationResponse({
    this.message,
    this.data,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) =>
      NotificationResponse(
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Notifications>.from(
                json["data"]!.map((x) => Notifications.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Notifications {
  int? id;
  String? user;
  String? notificationType;
  String? message;
  String? messageArabic;
  DateTime? createdAt;
  bool? isRead;
  String? source;
  String? propertyName;

  Notifications({
    this.id,
    this.user,
    this.notificationType,
    this.message,
    this.createdAt,
    this.isRead,
    this.source,
    this.propertyName,
    this.messageArabic,
  });

  factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
      id: json["id"],
      user: json["user"],
      notificationType: json["notification_type"],
      message: json["message"],
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      isRead: json["is_read"],
      source: json["source"],
      propertyName: json["property_name"],
      messageArabic: json['message_arabic']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "notification_type": notificationType,
        "message": message,
        "created_at": createdAt?.toIso8601String(),
        "is_read": isRead,
        "source": source,
        "property_name": propertyName,
        "message_arabic": messageArabic,
      };
}
