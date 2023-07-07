import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controllers/auth_controller.dart';
import '../controllers/chat_room_controller.dart';

class ChatRoomView extends GetView<ChatRoomController> {
  final authC = Get.find<AuthController>();
  final String chat_id = (Get.arguments as Map<String, dynamic>)["chat_id"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          toolbarHeight: 70,
          leadingWidth: 100,
          leading: InkWell(
            onTap: () => Get.back(),
            borderRadius: BorderRadius.circular(100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 5),
                Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                SizedBox(width: 5),
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey,
                  child: StreamBuilder<DocumentSnapshot<Object?>>(
                      stream: controller.streamFriendData(
                        (Get.arguments as Map<String, dynamic>)["friendEmail"],
                      ),
                      builder: (context, snapFriendUser) {
                        if (snapFriendUser.connectionState ==
                            ConnectionState.active) {
                          var dataFriend = snapFriendUser.data!.data()
                              as Map<String, dynamic>;
                          if (dataFriend["photoURL"] == "noimage") {
                            return ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset("assets/logo/noimage.png"));
                          } else {
                            return ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(dataFriend["photoURL"]));
                          }
                        }
                        return ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset("assets/logo/noimage.png"));
                      }),
                ),
              ],
            ),
          ),
          title: StreamBuilder<DocumentSnapshot<Object?>>(
            stream: controller.streamFriendData(
              (Get.arguments as Map<String, dynamic>)["friendEmail"],
            ),
            builder: (context, snapFriendUser) {
              if (snapFriendUser.connectionState == ConnectionState.active) {
                var dataFriend =
                    snapFriendUser.data!.data() as Map<String, dynamic>;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${dataFriend["name"]}',
                      style: TextStyle(fontSize: 18),
                    ),
                    dataFriend["status"] != ""
                        ? Text(
                            '${dataFriend["status"]}',
                            style: TextStyle(fontSize: 15),
                          )
                        : Text('', style: TextStyle(fontSize: 0)),
                  ],
                );
              }
              return SizedBox();
            },
          ),
        ),
        body: WillPopScope(
          onWillPop: () {
            if (controller.isShowEmoji.isTrue) {
              controller.isShowEmoji.value = false;
            } else {
              Navigator.pop(context);
            }
            return Future.value(false);
          },
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: Get.width,
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: controller.streamChat(chat_id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        print(snapshot.data);
                        var allChatsBerdua = snapshot.data!.docs;
                        Timer(
                            Duration.zero,
                            () => controller.scrollC.jumpTo(
                                controller.scrollC.position.maxScrollExtent));
                        return ListView.builder(
                            controller: controller.scrollC,
                            itemCount: allChatsBerdua.length,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Column(
                                  children: [
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      '${allChatsBerdua[index]["groupTime"]}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey),
                                    ),
                                    itemChat(
                                      isSender: allChatsBerdua[index]
                                                  ["pengirim"] ==
                                              authC.user.value.email
                                          ? true
                                          : false,
                                      msg: "${allChatsBerdua[index]["msg"]}",
                                      time: "${allChatsBerdua[index]["time"]}",
                                    ),
                                  ],
                                );
                              } else {
                                if (allChatsBerdua[index]["groupTime"] ==
                                    allChatsBerdua[index - 1]["groupTime"]) {
                                  return itemChat(
                                    isSender: allChatsBerdua[index]
                                                ["pengirim"] ==
                                            authC.user.value.email
                                        ? true
                                        : false,
                                    msg: "${allChatsBerdua[index]["msg"]}",
                                    time: "${allChatsBerdua[index]["time"]}",
                                  );
                                } else {
                                  return Column(
                                    children: [
                                      Text(
                                        '${allChatsBerdua[index]["groupTime"]}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey),
                                      ),
                                      itemChat(
                                        isSender: allChatsBerdua[index]
                                                    ["pengirim"] ==
                                                authC.user.value.email
                                            ? true
                                            : false,
                                        msg: "${allChatsBerdua[index]["msg"]}",
                                        time:
                                            "${allChatsBerdua[index]["time"]}",
                                      ),
                                    ],
                                  );
                                }
                              }
                            });
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),

                // child: ListView(
                //   children: [
                //     itemChat(msg: "Hallo Alfi", isSender: true),
                //     itemChat(msg: "iya Hallo juga", isSender: false),
                //   ],
                // )
              ),
              Container(
                margin:
                    EdgeInsets.only(bottom: context.mediaQueryPadding.bottom),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                width: Get.width,
                child: Row(children: [
                  Expanded(
                    child: Container(
                      child: TextField(
                        controller: controller.chatC,
                        focusNode: controller.focusNode,
                        onEditingComplete: () => controller.newChat(
                            authC.user.value.email!,
                            Get.arguments as Map<String, dynamic>,
                            controller.chatC.text),
                        decoration: InputDecoration(
                          prefixIcon: IconButton(
                            onPressed: () {
                              controller.isShowEmoji.toggle();
                              controller.focusNode.unfocus();
                            },
                            icon: Icon(Icons.emoji_emotions_outlined),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          hintText: "Tulis pesanmu...",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.blue,
                    child: InkWell(
                      onTap: () => controller.newChat(
                          authC.user.value.email!,
                          Get.arguments as Map<String, dynamic>,
                          controller.chatC.text),
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  )
                ]),
              ),
              Obx(() => (controller.isShowEmoji.isTrue)
                  ? Container(
                      height: 225,
                      child: EmojiPicker(
                        onEmojiSelected: (category, emoji) {
                          // Do something when emoji is tapped (optional)
                          controller.addEmojiToChat(emoji);
                        },
                        onBackspacePressed: () {
                          // Do something when the user taps the backspace button (optional)
                          // Set it to null to hide the Backspace-Button
                          controller.deleteEmoji();
                        },
                        // textEditingController:
                        //     textEditingController, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                        config: Config(
                          columns: 7,
                          emojiSizeMax: 32 *
                              (foundation.defaultTargetPlatform ==
                                      TargetPlatform.iOS
                                  ? 1.30
                                  : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
                          verticalSpacing: 0,
                          horizontalSpacing: 0,
                          gridPadding: EdgeInsets.zero,
                          initCategory: Category.RECENT,
                          bgColor: Color(0xFFF2F2F2),
                          indicatorColor: Colors.blue,
                          iconColor: Colors.grey,
                          iconColorSelected: Colors.blue,
                          backspaceColor: Colors.blue,
                          skinToneDialogBgColor: Colors.white,
                          skinToneIndicatorColor: Colors.grey,
                          enableSkinTones: true,
                          recentTabBehavior: RecentTabBehavior.RECENT,
                          recentsLimit: 28,
                          noRecents: const Text(
                            'No Recents',
                            style:
                                TextStyle(fontSize: 20, color: Colors.black26),
                            textAlign: TextAlign.center,
                          ), // Needs to be const Widget
                          loadingIndicator: const SizedBox
                              .shrink(), // Needs to be const Widget
                          tabIndicatorAnimDuration: kTabScrollDuration,
                          categoryIcons: const CategoryIcons(),
                          buttonMode: ButtonMode.MATERIAL,
                        ),
                      ),
                    )
                  : SizedBox()),
            ],
          ),
        ));
  }
}

class itemChat extends StatelessWidget {
  const itemChat({
    super.key,
    required this.isSender,
    required this.msg,
    required this.time,
  });

  final bool isSender;
  final String msg;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: isSender
                  ? BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    )
                  : BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(15),
                    ),
            ),
            padding: EdgeInsets.all(15),
            child: Text(
              "$msg",
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            DateFormat('HH:mm').format(DateTime.parse(time).toLocal()),
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
