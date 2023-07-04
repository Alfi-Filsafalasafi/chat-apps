import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:silaturrahmi/app/controllers/auth_controller.dart';
import 'package:silaturrahmi/app/utils/error_page.dart';

import 'app/routes/app_pages.dart';
import 'app/utils/loading_page.dart';
import 'app/utils/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _iniialization = Firebase.initializeApp();

  final authC = Get.put(AuthController(), permanent: true);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _iniialization,
        builder: (context, snapshot) {
          print(snapshot);
          if (snapshot.hasError) {
            return errorPage();
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return FutureBuilder(
                future: Future.delayed(Duration(seconds: 3)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Obx(
                      () => GetMaterialApp(
                        title: "Application",
                        initialRoute: authC.isSkipintro.isTrue
                            ? authC.isAuth.isTrue
                                ? Routes.HOME
                                : Routes.LOGIN
                            : Routes.INTRODUCTION,
                        getPages: AppPages.routes,
                      ),
                    );
                  }
                  return FutureBuilder(
                    future: authC.firstInitialized(),
                    builder: (context, snapshot) => splashScreen(),
                  );
                });
          } else {}

          return loading();
        });
  }
}
