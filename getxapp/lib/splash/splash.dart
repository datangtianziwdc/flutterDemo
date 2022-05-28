import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: Get.width,
            height: Get.height,
            child: Image.asset(
              "assets/images/login_bg.png",
              fit: BoxFit.fitHeight,
            ),
          ),
          Positioned(
              right: 20,
              top: 40,
              child: InkWell(
                onTap: () {
                  // Get.toNamed("/");
                  Get.offNamed("/");
                },
                child: Container(
                  color: Colors.black12,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    "跳过",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
