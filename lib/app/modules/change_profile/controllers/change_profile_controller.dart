import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ChangeProfileController extends GetxController {
  late TextEditingController emailC;
  late TextEditingController nameC;
  late TextEditingController statusC;
  late ImagePicker imgPicker;
  XFile? pickedImg = null;

  FirebaseStorage storage = FirebaseStorage.instance;

  Future<String?> uploadImage(String uid) async {
    Reference storageRef = storage.ref("$uid.png");
    File file = File(pickedImg!.path);
    try {
      await storageRef.putFile(file);
      final photoURL = await storageRef.getDownloadURL();
      resetImage();
      return photoURL;
    } catch (e) {
      print("Gagal karena $e");
      return null;
    }
  }

  void resetImage() {
    pickedImg = null;
    update();
  }

  void selectImage() async {
    try {
      final dataImage = await imgPicker.pickImage(source: ImageSource.gallery);
      if (dataImage != null) {
        print(dataImage.name);
        pickedImg = dataImage;
      }
      update();
    } catch (err) {
      print("gagal karena $err");
      pickedImg = null;

      update();
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    emailC = TextEditingController();
    nameC = TextEditingController();
    statusC = TextEditingController();
    imgPicker = ImagePicker();
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    emailC.dispose();
    nameC.dispose();
    statusC.dispose();
    super.onClose();
  }
}
