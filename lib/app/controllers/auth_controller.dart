import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:silaturrahmi/app/data/models/users_model.dart';

import '../routes/app_pages.dart';

class AuthController extends GetxController {
  var isSkipintro = false.obs;
  var isAuth = false.obs;

  //Buat Fungsi login dengan google
  GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _currentUser;
  UserCredential? userCredential;

  var user = UsersModel().obs;

  FirebaseFirestore firebase = FirebaseFirestore.instance;

  Future<void> firstInitialized() async {
    //mengubah isAtuh menjadi true agar auto login
    await autoLogin().then((value) {
      if (value) {
        isAuth.value = true;
      }
    });

    //menguba isSkipIntro menjadi true
    final box = GetStorage();
    if (box.read('isSkipIntro') != null || box.read('isSkipIntro') == true) {
      isSkipintro.value = true;
    }
  }

  Future<bool> autoLogin() async {
    try {
      final isSignIn = await _googleSignIn.isSignedIn();
      if (isSignIn) {
        await _googleSignIn
            .signInSilently()
            .then((value) => _currentUser = value);
        //mengambil user credentialnya
        final googleAuth = await _currentUser!.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) => userCredential = value);

        print("User Credential $userCredential");
        //menyimpan status user bahwa pernah melakukan login, sehingga skip untuk introduction page
        final box = GetStorage();
        if (box.read('isSkipIntro') != null) {
          box.remove('isSkipIntro');
        }
        box.write('isSkipIntro', true);
        print("is skip intro di autoLogin = $isSkipintro");

        //masukkan data user ke firebase
        CollectionReference users = firebase.collection('users');

        await users.doc(userCredential!.user!.email).update({
          "lastSignInTime":
              userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
        });

        //Mengambil data user yang sedang login
        final currentUser = await users.doc(userCredential!.user!.email).get();
        final currUserData = currentUser.data() as Map<String, dynamic>;

        //TODO : Fix List
        user(UsersModel.fromJson(currUserData));
        user.refresh();

        final listChats = await users
            .doc(userCredential!.user!.email)
            .collection("chats")
            .get();

        if (listChats.docs.length != 0) {
          List<ChatUsers> dataListChats = [];
          listChats.docs.forEach((element) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            dataListChats.add(ChatUsers(
              chatId: dataDocChatId,
              connection: dataDocChat["connection"],
              lastTime: dataDocChat["lastTime"],
              total_unread: dataDocChat["total_unread"],
            ));
          });
          user.update((user) {
            user!.chats = dataListChats;
          });
        } else {
          user.update((user) {
            user!.chats = [];
          });
        }

        user.refresh();
        return true;
      }
      return false;
    } catch (e) {
      print("Gagal karena $e");
    }
    return false;
  }

  Future<void> login() async {
    try {
      // mencegah kebocoran data sebelum user melakukan login
      //melakukan logout
      await _googleSignIn.signOut();

      //melakukan login dan mendapatkan google user account
      await _googleSignIn.signIn().then((value) => _currentUser = value);

      //mengecek status login user berhasil or tidak
      final isSignIn = await _googleSignIn.isSignedIn();
      if (isSignIn) {
        print("Berhasil Login");
        print("Ini datanya $_currentUser");

        //mengambil user credentialnya
        final googleAuth = await _currentUser!.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) => userCredential = value);

        print("User Credential $userCredential");

        //menyimpan status user bahwa pernah melakukan login, sehingga skip untuk introduction page
        final box = GetStorage();
        if (box.read('isSkipIntro') != null) {
          box.remove('isSkipIntro');
        }
        box.write('isSkipIntro', true);

        //masukkan data user ke firebase
        CollectionReference users = firebase.collection('users');

        final userLama = await users.doc(userCredential!.user!.email).get();

        if (userLama.data() == null) {
          await users.doc(userCredential!.user!.email).set({
            "uid": userCredential!.user!.uid,
            "name": userCredential!.user!.displayName!
                    .substring(0, 1)
                    .toUpperCase() +
                userCredential!.user!.displayName!.substring(1),
            "email": userCredential!.user!.email,
            "keyName": _currentUser!.displayName!.substring(0, 1).toUpperCase(),
            "photoURL": userCredential!.user!.photoURL ?? "noimage",
            "status": "",
            "creationTime": DateTime.now().toIso8601String(),
            "lastSignInTime": DateTime.now().toIso8601String(),
            "updatedTime": DateTime.now().toIso8601String(),
            // "chats": [],
          });
          await users.doc(userCredential!.user!.email).collection("chats");
        } else {
          await users.doc(userCredential!.user!.email).update({
            "lastSignInTime": DateTime.now().toIso8601String(),
          });
        }

        //mengambil data user yang sedang login
        final currentUser = await users.doc(userCredential!.user!.email).get();
        final currUserData = currentUser.data() as Map<String, dynamic>;

        //TODO : Fix List
        user(UsersModel.fromJson(currUserData));
        user.refresh();

        final listChats = await users
            .doc(userCredential!.user!.email)
            .collection("chats")
            .get();

        if (listChats.docs.length != 0) {
          List<ChatUsers> dataListChats = [];
          listChats.docs.forEach((element) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            dataListChats.add(ChatUsers(
              chatId: dataDocChatId,
              connection: dataDocChat["connection"],
              lastTime: dataDocChat["lastTime"],
              total_unread: dataDocChat["total_unread"],
            ));
          });
          user.update((user) {
            user!.chats = dataListChats;
          });
        } else {
          user.update((user) {
            user!.chats = [];
          });
        }

        user.refresh();

        isAuth.value = true;
        Get.offAllNamed(Routes.HOME);
      } else {
        print("Gagal Login");
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> logout() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }

  void changeProfile(String name, String status) async {
    CollectionReference users = firebase.collection('users');

    String dateNow = DateTime.now().toIso8601String();
    final keyName = name.substring(0, 1).toUpperCase();

    //update di collection User
    users.doc(userCredential!.user!.email).update({
      "name": name,
      "status": status,
      "keyName": keyName,
      "updatedTime": dateNow,
    });

    //update model user
    user.update((user) {
      user!.name = name;
      user.status = status;
      user.updatedTime = dateNow;
    });

    user.refresh();
    Get.defaultDialog(
        title: "Berhasil", middleText: "Anda sudah merubah profile anda");
  }

  void changeStatus(String status) async {
    CollectionReference users = firebase.collection('users');

    String dateNow = DateTime.now().toIso8601String();

    //update authentication
    users.doc(userCredential!.user!.email).update({
      "status": status,
      "updatedTime": dateNow,
    });

    //update model user
    user.update((user) {
      user!.status = status;
      user.lastSignInTime = dateNow;
    });

    user.refresh();

    Get.defaultDialog(
        title: "Berhasil", middleText: "Anda sudah merubah profile anda");
  }

  //fungsi digunakan untuk menghubungkan 2 orang saat akan memulai chat
  void addNewConnection(String friendEmail) async {
    bool flagNewConnection = false;
    var chat_id;
    String dateNow = DateTime.now().toIso8601String();
    CollectionReference chats = firebase.collection("chats");
    CollectionReference users = firebase.collection("users");

    final docChats =
        await users.doc(_currentUser!.email).collection("chats").get();

    if (docChats.docs.length != 0) {
      //sudah pernah melakukan chat sama siapapun
      final checkConnection = await users
          .doc(_currentUser!.email)
          .collection("chats")
          .where("connection", isEqualTo: friendEmail)
          .get();
      if (checkConnection.docs.length != 0) {
        //sudah pernah buat koneksi dengan  friend Email
        flagNewConnection = false;
        chat_id = checkConnection.docs[0].id;
      } else {
        //belum pernah buat koneksi dengan friendEmail
        //buat koneksi
        flagNewConnection = true;
      }
    } else {
      //belum pernah melakukan chat dengan siapapun
      flagNewConnection = true;
    }

    if (flagNewConnection == true) {
      // mengecek collection chat dimana connection dari friendEmail dan user yang sedang login
      final chatsDocs = await chats.where("connection", whereIn: [
        [
          _currentUser!.email,
          friendEmail,
        ],
        [
          friendEmail,
          _currentUser!.email,
        ],
      ]).get();

      if (chatsDocs.docs.length != 0) {
        //user pernah terhubung dengan friend, karena friend pernah menghubungkannya dengan user
        final chatsData = chatsDocs.docs[0].data() as Map<String, dynamic>;
        final chatsID = chatsDocs.docs[0].id;

        await users
            .doc(_currentUser!.email)
            .collection("chats")
            .doc(chatsID)
            .set({
          "connection": friendEmail,
          "lastTime": chatsData["lastTime"],
          "total_unread": 0
        });
        final listChats = await users
            .doc(userCredential!.user!.email)
            .collection("chats")
            .get();

        if (listChats.docs.length != 0) {
          List<ChatUsers> dataListChats = [];
          listChats.docs.forEach((element) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            dataListChats.add(ChatUsers(
              chatId: dataDocChatId,
              connection: dataDocChat["connection"],
              lastTime: dataDocChat["lastTime"],
              total_unread: dataDocChat["total_unread"],
            ));
          });
          user.update((user) {
            user!.chats = dataListChats;
          });
        } else {
          user.update((user) {
            user!.chats = [];
          });
        }

        chat_id = chatsID;

        user.refresh();
      } else {
        //user belum pernah sama sekali terhubung
        final newChat = await chats.add({
          "connection": [
            _currentUser!.email,
            friendEmail,
          ],
        });

        await chats.doc(newChat.id).collection("chat");

        await users
            .doc(_currentUser!.email)
            .collection("chats")
            .doc(newChat.id)
            .set({
          "connection": friendEmail,
          "lastTime": dateNow,
          "total_unread": 0
        });
        final listChats =
            await users.doc(_currentUser!.email).collection("chats").get();

        if (listChats.docs.length != 0) {
          List<ChatUsers> dataListChats = [];
          listChats.docs.forEach((element) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            dataListChats.add(ChatUsers(
              chatId: dataDocChatId,
              connection: dataDocChat["connection"],
              lastTime: dataDocChat["lastTime"],
              total_unread: dataDocChat["total_unread"],
            ));
          });
          user.update((user) {
            user!.chats = dataListChats;
          });
        } else {
          user.update((user) {
            user!.chats = [];
          });
        }

        chat_id = newChat.id;

        user.refresh();
      }
    }
    Get.toNamed(Routes.CHAT_ROOM, arguments: {
      "chat_id": "$chat_id",
      "friendEmail": friendEmail,
    });
  }
}
