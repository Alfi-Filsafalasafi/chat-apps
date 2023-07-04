import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../routes/app_pages.dart';
import '../controllers/search_friend_controller.dart';

class SearchFriendView extends GetView<SearchFriendController> {
  final List<Widget> friends = List.generate(
    20,
    (index) => ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.black12,
        child: Image.asset("assets/logo/noimage.png"),
      ),
      title: Text(
        "Orang ke ${index + 1}",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        "Status orang ke ${index + 1}",
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
      trailing: GestureDetector(
        onTap: () => Get.toNamed(Routes.CHAT_ROOM),
        child: Chip(
          backgroundColor: Colors.blue,
          label: Text(
            "Message",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    ),
  );

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
      body: friends.length == 0
          ? Center(
              child: Container(
                width: Get.width * 0.7,
                height: Get.height * 0.7,
                child: Lottie.asset("assets/lottie/empty.json"),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.only(top: 5),
              itemCount: friends.length,
              itemBuilder: (context, index) => friends[index],
            ),
    );
  }
}
