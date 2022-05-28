import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getxapp/controller.dart';
import 'package:getxapp/audio/audioPage.dart';
import 'package:getxapp/danmu/danmu.dart';
import 'package:getxapp/animationPage/animationPage.dart';
import 'package:getxapp/signPage/signPage.dart';
import 'package:getxapp/splash/splash.dart';
import 'package:getxapp/keyPage/keyPage.dart';


void main() {
  runApp(GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // home: Home(),
      initialRoute: "/login",
      getPages: [
        GetPage(name: "/", page: () => const Home()),
        GetPage(name: "/other", page: () => Other()),
        GetPage(name: "/login", page: () => const SplashPage()),
        GetPage(name: "/audioPage", page: () => const AudioPage()),
        GetPage(name: "/danmuPage", page: () => const Danmu()),
        GetPage(name: "/animation", page: () => const AnimationPage()),
        GetPage(name: "/keyPage", page: () => const KeyPage()),
        GetPage(name: "/signPage", page: () => const SignPage())
      ],
      routingCallback: (value) => {debugPrint("路由回调${value.toString()}")}));
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("GETX"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            height: 50,
            alignment: Alignment.center,
            color: Colors.amber,
            child: Obx(() => Text(controller.count.toString())),
          ),
          Container(
            height: 50,
            alignment: Alignment.center,
            color: Colors.amber,
            child: GetX<HomeController>(
                builder: (controller) =>
                    Text(controller.count1.value.toString())),
          ),
          Container(
            height: 50,
            alignment: Alignment.center,
            color: Colors.amber,
            child: GetBuilder<HomeController>(
              builder: (controller) {
                return Text(controller.count2.toString());
              },
            ),
          ),
          Container(
            height: 50,
            alignment: Alignment.center,
            color: Colors.amber,
            child: ElevatedButton(
              onPressed: () async {
                // Get.to(() => Other());
                // var res = await Get.to(() => Other(),
                //     arguments: {"name": "王大锤", "age": "18"});
                var res = await Get.toNamed("/other",
                    arguments: {"name": "王大锤", "age": "18"});
                debugPrint("回调参数${res.toString()}");
              },
              child: const Text("Router"),
            ),
          ),
          Container(
            height: 50,
            alignment: Alignment.center,
            color: Colors.amber,
            child: ElevatedButton(
              onPressed: () {
                Get.snackbar("标题", "信息",
                    colorText: Colors.white,
                    backgroundColor: Colors.black54,
                    duration: const Duration(milliseconds: 1000),
                    snackPosition: SnackPosition.BOTTOM,
                    titleText: const Text(
                      "新标题",
                      style: TextStyle(color: Colors.yellow),
                    ));
              },
              child: const Text("SnackBar"),
            ),
          ),
          Container(
            height: 50,
            alignment: Alignment.center,
            color: Colors.amber,
            child: ElevatedButton(
              onPressed: () {
                Get.defaultDialog(
                  barrierDismissible: false,
                  title: "弹出",
                  confirm: ElevatedButton(
                    onPressed: () {
                      Get.back(closeOverlays: true);
                    },
                    child: const Text("确认"),
                  ),
                );
              },
              child: const Text("Dialog"),
            ),
          ),
          Container(
            height: 50,
            alignment: Alignment.center,
            color: Colors.amber,
            child: ElevatedButton(
              onPressed: () {
                Get.bottomSheet(Container(
                  height: 300,
                  color: Colors.white,
                  child: ListView(
                    children: const [
                      ListTile(
                          title: Text("重启"),
                          leading: Icon(Icons.access_alarms)),
                      ListTile(
                        title: Text("注销"),
                      ),
                      ListTile(
                        title: Text("关机"),
                      )
                    ],
                  ),
                ));
              },
              child: const Text("BottomSheet"),
            ),
          ),
          Container(
            height: 50,
            alignment: Alignment.center,
            color: Colors.amber,
            child: ElevatedButton(
              onPressed: () {
                controller.increment1();
              },
              child: const Text("increment1"),
            ),
          ),
          Container(
            height: 50,
            alignment: Alignment.center,
            color: Colors.amber,
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed("/audioPage");
              },
              child: const Text("读取MP3"),
            ),
          ),
          Container(
            height: 50,
            alignment: Alignment.center,
            color: Colors.amber,
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed("/danmuPage");
              },
              child: const Text("弹幕"),
            ),
          ),
          Container(
            height: 50,
            alignment: Alignment.center,
            color: Colors.amber,
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed("/animation");
              },
              child: const Text("动画"),
            ),
          ),
          Container(
            height: 50,
            alignment: Alignment.center,
            color: Colors.amber,
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed("/keyPage");
              },
              child: const Text("KEY"),
            ),
          ),
          Container(
            height: 50,
            alignment: Alignment.center,
            color: Colors.amber,
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed("/signPage");
              },
              child: const Text("签名"),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          controller.increment();
        },
      ),
    );
  }
}

class Other extends StatelessWidget {
  Other({Key? key}) : super(key: key);
  final HomeController c = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Other"),
          centerTitle: true,
          leading: GestureDetector(
            child: const Icon(Icons.arrow_back_ios),
            onTap: () {
              Get.back(result: "back");
            },
          ),
        ),
        body: Center(
          child: Column(
            children: [
              Text(c.count.toString()),
              Text(Get.arguments['name'].toString()),
              Text(Get.arguments['age'].toString())
            ],
          ),
        ));
  }
}