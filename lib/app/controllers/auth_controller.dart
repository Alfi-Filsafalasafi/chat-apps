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

  UserModel user = UserModel();

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
    if (box.read('skipIntro') != null || box.read('skipIntro') == true) {
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

        //masukkan data user ke firebase
        CollectionReference users = firebase.collection('users');

        users.doc(userCredential!.user!.email).update({
          "lastSignInTime":
              userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
        });

        //Mengambil data user yang sedang login
        final currentUser = await users.doc(userCredential!.user!.email).get();
        final currUserData = currentUser.data() as Map<String, dynamic>;

        user = UserModel(
          uid: currUserData["uid"],
          name: currUserData["name"],
          email: currUserData["email"],
          status: currUserData["status"],
          photoURL: currUserData["photoURL"],
          creationTime: currUserData["creationTime"],
          lastSignInTime: currUserData["lastSignInTime"],
          updatedTime: currUserData["updatedTime"],
        );

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
        if (box.read('skipIntro') != null) {
          box.remove('skipIntro');
        }
        box.write('skipIntro', true);

        //masukkan data user ke firebase
        CollectionReference users = firebase.collection('users');

        final userLama = await users.doc(userCredential!.user!.email).get();

        if (userLama.data() == null) {
          users.doc(userCredential!.user!.email).set({
            "uid": userCredential!.user!.uid,
            "name": userCredential!.user!.displayName,
            "email": userCredential!.user!.email,
            "photoURL": userCredential!.user!.photoURL ?? "noimage",
            "status": "",
            "creationTime":
                userCredential!.user!.metadata.creationTime!.toIso8601String(),
            "lastSignInTime": userCredential!.user!.metadata.lastSignInTime!
                .toIso8601String(),
            "updatedTime": DateTime.now().toIso8601String(),
          });
        } else {
          users.doc(userCredential!.user!.email).update({
            "lastSignInTime": userCredential!.user!.metadata.lastSignInTime!
                .toIso8601String(),
          });
        }

        //mengambil data user yang sedang login
        final currentUser = await users.doc(userCredential!.user!.email).get();
        final currUserData = currentUser.data() as Map<String, dynamic>;

        user = UserModel(
          uid: currUserData["uid"],
          name: currUserData["name"],
          email: currUserData["email"],
          status: currUserData["status"],
          photoURL: currUserData["photoURL"],
          creationTime: currUserData["creationTime"],
          lastSignInTime: currUserData["lastSignInTime"],
          updatedTime: currUserData["updatedTime"],
        );

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
}
