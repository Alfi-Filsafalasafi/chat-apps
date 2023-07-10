import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:silaturrahmi/app/controllers/auth_controller.dart';
import 'package:silaturrahmi/app/routes/app_pages.dart';
import 'package:silaturrahmi/main.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0,
          title: const Text('ProfileView'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () => authC.logout(),
              icon: Icon(
                Icons.logout,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              child: Column(
                children: [
                  Obx(
                    () => AvatarGlow(
                      endRadius: 100,
                      glowColor: Colors.blue,
                      duration: Duration(seconds: 2),
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                        width: 125,
                        height: 125,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(200),
                          child: authC.user.value.photoURL! == "noimage"
                              ? Image.asset(
                                  "asset/images/noimage.png",
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  authC.user.value.photoURL!,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => Text(
                      "${authC.user.value.name!}",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text(
                    "${authC.user.value.email!}",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: Container(
                  child: Column(
                children: [
                  ListTile(
                    onTap: () => Get.toNamed(Routes.UPDATE_STATUS),
                    leading: Icon(Icons.note_add_outlined),
                    title: Text(
                      "Update Status",
                      style: TextStyle(fontSize: 18),
                    ),
                    trailing: Icon(Icons.arrow_right),
                  ),
                  ListTile(
                    onTap: () => Get.toNamed(Routes.CHANGE_PROFILE),
                    // onTap: () => print(Get.isDarkMode),
                    leading: Icon(Icons.person_2_outlined),
                    title: Text(
                      "Change Profile",
                      style: TextStyle(fontSize: 18),
                    ),
                    trailing: Icon(Icons.arrow_right),
                  ),
                  ListTile(
                    onTap: () => Get.changeThemeMode(
                        Get.isDarkMode ? ThemeMode.light : ThemeMode.dark),
                    leading: Icon(Icons.color_lens_outlined),
                    title: Text(
                      "Change Theme nih",
                      style: TextStyle(fontSize: 18),
                    ),
                    trailing: Text(
                      "Light",
                      style: TextStyle(color: Colors.blue),
                    ),
                  )
                ],
              )),
            ),
            Container(
              margin:
                  EdgeInsets.only(bottom: context.mediaQueryPadding.top + 10),
              child: Column(
                children: [Text("Silaturrahmi app"), Text("v1.0")],
              ),
            ),
          ],
        ));
  }
}
