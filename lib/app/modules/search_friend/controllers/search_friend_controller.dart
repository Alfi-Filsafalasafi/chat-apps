import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchFriendController extends GetxController {
  //TODO: Implement SearchFriendController

  late TextEditingController searchC;

  @override
  void onInit() {
    // TODO: implement onInit
    searchC = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    searchC.dispose();
    super.onClose();
  }
}
