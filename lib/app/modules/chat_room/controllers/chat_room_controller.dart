import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatRoomController extends GetxController {
  var isShowEmoji = false.obs;
  int total_unread = 0;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  late FocusNode focusNode;

  late TextEditingController chatC;

  void addEmojiToChat(Emoji emoji) {
    chatC.text = chatC.text + emoji.emoji;
  }

  void deleteEmoji() {
    chatC.text = chatC.text.substring(0, chatC.text.length - 2);
  }

  void newChat(String email, Map<String, dynamic> argument, String chat) async {
    CollectionReference chats = firestore.collection("chats");
    CollectionReference users = firestore.collection("users");

    String dateNow = DateTime.now().toIso8601String();

    final newChat =
        await chats.doc(argument["chat_id"]).collection("chat").add({
      "pengirim": email,
      "penerima": argument["friendEmail"],
      "msg": chat,
      "time": dateNow,
      "isRead": false,
    });

    total_unread += 1; //untuk friendEmail

    //melakukan update lastTime yang ada di collection users => chats
    await users.doc(email).collection("chats").doc(argument["chat_id"]).update({
      "lastTime": dateNow,
    });

    //mengecek apakah di friendEmail sudah memiliki chat_id dari kita yg sedang login
    final checkChatsFriend = await users
        .doc(argument["friendEmail"])
        .collection("chats")
        .doc(argument["chat_id"])
        .get();
    if (checkChatsFriend.exists) {
      //update
      //mengecek total unread
      final checkTotalUnread = await chats
          .doc(argument["chat_id"])
          .collection("chat")
          .where("isRead", isEqualTo: false)
          .where("pengirim", isEqualTo: email)
          .get();

      //total unread for friend
      total_unread = checkTotalUnread.docs.length;

      await users
          .doc(argument["friendEmail"])
          .collection("chats")
          .doc(argument["chat_id"])
          .update({
        "lastTime": dateNow,
        "total_unread": total_unread,
      });
    } else {
      //buat baru
      await users
          .doc(argument["friendEmail"])
          .collection("chats")
          .doc(argument["chat_id"])
          .set({
        "connection": email,
        "lastTime": dateNow,
        "total_unread": 1,
      });
    }

    print("Berhasil mengechat dengan kata $chat");
  }

  @override
  void onInit() {
    // TODO: implement onInit
    chatC = TextEditingController();
    focusNode = FocusNode();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        isShowEmoji.value = false;
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    chatC.dispose();
    // TODO: implement onClose
    focusNode.dispose();
    super.onClose();
  }
}
