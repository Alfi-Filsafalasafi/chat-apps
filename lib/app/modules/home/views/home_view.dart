import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: context.mediaQueryPadding.top),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.black12),
              ),
            ),
            padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Chat",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                ),
                Material(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.blue[600],
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () => Get.toNamed(Routes.PROFILE),
                    child: Container(
                      width: 36,
                      height: 36,
                      child: Obx(
                        () => ClipRRect(
                          borderRadius: BorderRadius.circular(200),
                          child: authC.user.value.photoURL == "noimage"
                              ? Image.asset("assets/image/noimage")
                              : Image.network(
                                  authC.user.value.photoURL!,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: controller.chatStream(authC.user.value.email!),
              builder: (context, snapshot1) {
                print(snapshot1);
                if (snapshot1.connectionState == ConnectionState.active) {
                  var allChat = snapshot1.data!.docs;
                  return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: allChat.length,
                      itemBuilder: (context, index) {
                        return StreamBuilder<
                            DocumentSnapshot<Map<String, dynamic>>>(
                          stream: controller
                              .friendStream(allChat[index]["connection"]),
                          builder: (context, snapshot2) {
                            if (snapshot2.connectionState ==
                                ConnectionState.active) {
                              var data = snapshot2.data!.data();

                              return ListTile(
                                onTap: () => controller.goToChatRoom(
                                    "${allChat[index].id}",
                                    authC.user.value.email!,
                                    "${allChat[index]["connection"]}"),
                                leading: Container(
                                  height: 45,
                                  width: 45,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: data!["photoURL"] == "noimage"
                                        ? Image.asset("assets/logo/noimage.png")
                                        : Image.network(
                                            "${data["photoURL"]}",
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                                title: Text(
                                  "${data["name"]}",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                                subtitle: data["status"] != ""
                                    ? Text(
                                        "${data["status"]}",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      )
                                    : null,
                                trailing: allChat[index]["total_unread"] == 0
                                    ? SizedBox()
                                    : Chip(
                                        backgroundColor: Colors.blue,
                                        label: Text(
                                          "${allChat[index]["total_unread"]}",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                              );
                            }
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        );
                      });
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.SEARCH_FRIEND),
        child: Icon(
          Icons.message_rounded,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue[600],
      ),
    );
  }
}
