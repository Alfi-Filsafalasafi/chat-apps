import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:silaturrahmi/app/controllers/auth_controller.dart';

import '../controllers/change_profile_controller.dart';

class ChangeProfileView extends GetView<ChangeProfileController> {
  final authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    controller.emailC.text = authC.user.value.email!;
    controller.nameC.text = authC.user.value.name!;
    controller.statusC.text = authC.user.value.status ?? "";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              authC.changeProfile(
                controller.nameC.text,
                controller.statusC.text,
              );
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              AvatarGlow(
                endRadius: 100,
                glowColor: Colors.blue,
                duration: Duration(seconds: 2),
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                  width: 125,
                  height: 125,
                  child: Obx(
                    () => ClipRRect(
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
              TextField(
                controller: controller.emailC,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: controller.nameC,
                decoration: InputDecoration(
                  labelText: "Nama",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: controller.statusC,
                decoration: InputDecoration(
                  labelText: "Status",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GetBuilder<ChangeProfileController>(
                    builder: (c) => c.pickedImg != null
                        ? Column(
                            children: [
                              Container(
                                height: 125,
                                width: 125,
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        image: DecorationImage(
                                          image: FileImage(
                                            File(c.pickedImg!.path),
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: -5,
                                      right: -10,
                                      child: IconButton(
                                        onPressed: () => c.resetImage(),
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              TextButton(
                                  onPressed: () => c
                                          .uploadImage(authC.user.value.uid!)
                                          .then((hasilKembalian) {
                                        if (hasilKembalian != null) {
                                          authC.updatePhotoProfile(
                                              hasilKembalian);
                                        }
                                      }),
                                  child: Text("Upload"))
                            ],
                          )
                        : Text(
                            "no image",
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                  TextButton(
                    onPressed: () => controller.selectImage(),
                    child: Text(
                      "choose...",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                width: Get.width,
                child: ElevatedButton(
                  onPressed: () {
                    authC.changeProfile(
                      controller.nameC.text,
                      controller.statusC.text,
                    );
                  },
                  child: Text("update"),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 20)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
