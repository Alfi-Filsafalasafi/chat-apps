import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final List<Widget> myChats = List.generate(
    20,
    (index) => ListTile(
      onTap: () => Get.toNamed(Routes.CHAT_ROOM),
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
      trailing: Chip(
        label: Text("3"),
      ),
    ),
  ).reversed.toList();
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
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Icon(
                        Icons.person,
                        size: 26,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 5),
              itemCount: myChats.length,
              itemBuilder: (context, index) => myChats[index],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.SEARCH_FRIEND),
        child: Icon(Icons.message_rounded),
        backgroundColor: Colors.blue[600],
      ),
    );
  }
}
