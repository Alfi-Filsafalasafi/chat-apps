import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:silaturrahmi/app/controllers/auth_controller.dart';

import 'app/routes/app_pages.dart';
import 'app/utils/splash_screen.dart';

final ThemeData light = ThemeData(
  brightness: Brightness.light,
);

final ThemeData dark = ThemeData(
  brightness: Brightness.dark,
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: TextStyle(color: const Color.fromARGB(255, 202, 202, 202)),
    labelStyle:
        TextStyle(color: Colors.black) // Mengatur warna teks placeholder
    ,
    fillColor: Colors.grey, // Mengatur warna teks label
  ),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (value) => runApp(MyApp()),
  );
}

class MyApp extends StatelessWidget {
  final authC = Get.put(AuthController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(
          Duration(seconds: 3),
          () => authC.firstInitialized(),
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Obx(
              () => GetMaterialApp(
                title: "Application",
                theme: light,
                darkTheme: dark,
                initialRoute: authC.isSkipIntro.isTrue
                    ? authC.isAuth.isTrue
                        ? Routes.HOME
                        : Routes.LOGIN
                    : Routes.INTRODUCTION,
                getPages: AppPages.routes,
              ),
            );
          }
          return splashScreen();
        });
  }
}
