// To parse this JSON data, do
//
//     final usersModel = usersModelFromJson(jsonString);

import 'dart:convert';

UsersModel usersModelFromJson(String str) =>
    UsersModel.fromJson(json.decode(str));

String usersModelToJson(UsersModel data) => json.encode(data.toJson());

class UsersModel {
  String? uid;
  String? name;
  String? email;
  String? keyName;
  String? status;
  String? creationTime;
  String? lastSignInTime;
  String? updatedTime;
  String? photoURL;
  List<ChatUsers>? chats;

  UsersModel({
    this.uid,
    this.name,
    this.email,
    this.status,
    this.creationTime,
    this.lastSignInTime,
    this.updatedTime,
    this.keyName,
    this.photoURL,
    this.chats,
  });

  factory UsersModel.fromJson(Map<String, dynamic> json) => UsersModel(
        uid: json["uid"],
        name: json["name"],
        email: json["email"],
        status: json["status"],
        keyName: json["keyName"],
        creationTime: json["creationTime"],
        lastSignInTime: json["lastSignInTime"],
        updatedTime: json["updatedTime"],
        photoURL: json["photoURL"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "email": email,
        "status": status,
        "keyName": keyName,
        "creationTime": creationTime,
        "lastSignInTime": lastSignInTime,
        "updatedTime": updatedTime,
        "photoURL": photoURL,
      };
}

class ChatUsers {
  String? chatId;
  String? lastTime;
  int? total_unread;
  String? connection;

  ChatUsers({
    this.chatId,
    this.lastTime,
    this.total_unread,
    this.connection,
  });

  factory ChatUsers.fromJson(Map<String, dynamic> json) => ChatUsers(
        chatId: json["chat_id"],
        lastTime: json["lastTime"],
        total_unread: json["total_unread"],
        connection: json["connection"],
      );

  Map<String, dynamic> toJson() => {
        "chat_id": chatId,
        "lastTime": lastTime,
        "total_unread": total_unread,
        "connection": connection,
      };
}
