import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../routes/app_pages.dart';

class AuthController extends GetxController {
  var isSkipintro = false.obs;
  var isAuth = false.obs;

  //Buat Fungsi login dengan google
  GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _currentUser;
  UserCredential? userCredential;

  Future<void> firstInitialized() async {
    //mengubah isAtuh menjadi true agar auto login
    try {
      final isSignIn = await _googleSignIn.isSignedIn();
      if (isSignIn) {
        isAuth.value = true;
      }
    } catch (e) {
      print("Gagal karena $e");
    }

    //menguba isSkipIntro menjadi true
    final box = GetStorage();
    if (box.read('skipIntro') != null || box.read('skipIntro') == true) {
      isSkipintro.value = true;
    }
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
