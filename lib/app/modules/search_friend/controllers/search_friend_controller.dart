import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchFriendController extends GetxController {
  //TODO: Implement SearchFriendController

  late TextEditingController searchC;
  FirebaseFirestore firebase = FirebaseFirestore.instance;

  var quearyAwal = [].obs;
  var tempSearch = [].obs;

  void searchFriend(String data, String email) async {
    print("Search : $data");

    if (data.length == 0) {
      quearyAwal.value = [];
      tempSearch.value = [];
    } else {
      var capitalized = data.substring(0, 1).toUpperCase() + data.substring(1);
      print(capitalized);

      if (quearyAwal.length == 0 && data.length == 1) {
        //fungsi yang akan dijalankan pada saat ketikan pertama
        CollectionReference users = firebase.collection("users");
        final keyNameResult = await users
            .where("keyName", isEqualTo: data.substring(0, 1).toUpperCase())
            .where("email", isNotEqualTo: email)
            .get();
        print("Total data : ${keyNameResult.docs.length}");

        if (keyNameResult.docs.length > 0) {
          for (int i = 0; i < keyNameResult.docs.length; i++) {
            quearyAwal
                .add(keyNameResult.docs[i].data() as Map<String, dynamic>);
          }
          print("Query Result :");
          print(quearyAwal);
        } else {
          print("Tidak ada Query");
        }
      }

      if (quearyAwal.length != 0) {
        tempSearch.value = [];
        quearyAwal.forEach((element) {
          if (element["name"].startsWith(capitalized)) {
            tempSearch.add(element);
          }
        });
        print("tempSearch : $tempSearch");
      }
    }
    quearyAwal.refresh();
    tempSearch.refresh();
  }

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
