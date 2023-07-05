import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:silaturrahmi/app/controllers/auth_controller.dart';

import '../../../routes/app_pages.dart';
import '../controllers/search_friend_controller.dart';

class SearchFriendView extends GetView<SearchFriendController> {
  final authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(140),
        child: AppBar(
          title: const Text('SearchFriendView'),
          centerTitle: true,
          flexibleSpace: Padding(
            padding: const EdgeInsets.fromLTRB(30, 10, 30, 20),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: TextField(
                onChanged: (value) =>
                    controller.searchFriend(value, authC.user.value.email!),
                controller: controller.searchC,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 1,
                    ),
                  ),
                  hintText: "Search new friend here....",
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  suffixIcon: InkWell(
                      onTap: () {
                        print("Hallo");
                      },
                      child: Icon(Icons.search)),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Obx(
        () => controller.tempSearch.length == 0
            ? Center(
                child: Container(
                  width: Get.width * 0.7,
                  height: Get.height * 0.7,
                  child: Lottie.asset("assets/lottie/empty.json"),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.only(top: 5),
                itemCount: controller.tempSearch.length,
                itemBuilder: (context, index) => ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.black12,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(200),
                      child:
                          controller.tempSearch[index]["photoURL"] == "noimage"
                              ? Image.asset("assets/logo/noimage.png")
                              : Image.network(
                                  controller.tempSearch[index]["photoURL"],
                                ),
                    ),
                  ),
                  title: Text(
                    "${controller.tempSearch[index]["name"]}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    "${controller.tempSearch[index]["email"]}",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  trailing: GestureDetector(
                    onTap: () => authC.addNewConnection(
                        controller.tempSearch[index]["email"]),
                    child: Chip(
                      backgroundColor: Colors.blue,
                      label: Text(
                        "Message",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
