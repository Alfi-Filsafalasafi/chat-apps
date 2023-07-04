import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:silaturrahmi/app/routes/app_pages.dart';

import '../controllers/introduction_controller.dart';

class IntroductionView extends GetView<IntroductionController> {
  const IntroductionView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        pages: [
          PageViewModel(
            title: "Interaksi dengan mudah",
            body:
                "Darimana saja dan kapan saja, lakukan interaksi dengan siapa saja",
            image: Container(
                width: Get.width * 0.6,
                height: Get.width * 0.6,
                child: Lottie.asset("assets/lottie/main-laptop-duduk.json")),
          ),
          PageViewModel(
            title: "Temukan Teman Baru",
            body: "Cari teman baru, langsung kenalan dan mulai interaksi",
            image: Container(
                width: Get.width * 0.6,
                height: Get.width * 0.6,
                child: Lottie.asset("assets/lottie/ojek.json")),
          ),
          PageViewModel(
            title: "Aplikasi bebas biaya",
            body:
                "Berteman dengan siapa saja, interaksi setiap saat tanpa khawatir masalah biaya",
            image: Container(
                width: Get.width * 0.6,
                height: Get.width * 0.6,
                child: Lottie.asset("assets/lottie/payment.json")),
          ),
          PageViewModel(
            title: "Gabung Sekarang Juga",
            body:
                "Daftarkan dirimu dan Mulai interaksimu dengan orang diluar sana",
            image: Container(
                width: Get.width * 0.6,
                height: Get.width * 0.6,
                child: Lottie.asset("assets/lottie/register.json")),
          ),
        ],
        showSkipButton: true,
        skip: const Text("Skip"),
        next: const Text(
          "Next",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w700)),
        onDone: () => Get.offAllNamed(Routes.LOGIN),
        dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeColor: Theme.of(context).colorScheme.secondary,
          color: Colors.black26,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        ),
      ),
    );
  }
}
