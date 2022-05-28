import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:get/get.dart';
import 'package:getxapp/danmu/controller.dart';

class Danmu extends StatelessWidget {
  const Danmu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DanmuController(), tag: "danmuPageController");
    Widget viewItem(index) {
      return Container(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
        child: Text.rich(TextSpan(children: [
          WidgetSpan(
              alignment: ui.PlaceholderAlignment.middle,
              child: Container(
                margin: const EdgeInsets.only(bottom: 3),
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                    color: Colors.blue[900],
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  "LV$index",
                  style: const TextStyle(color: Colors.white, fontSize: 8),
                ),
              )),
          TextSpan(
              text: '  用户名$index',
              style: const TextStyle(color: Colors.cyan, fontSize: 12)),
          const TextSpan(
              text: '  文本内容文本内容文本内容文本内容文本内容文本内容文本内容文本内容文本内容文本内容文本内容',
              style: TextStyle(color: Colors.white, fontSize: 12)),
        ])),
      );
    }

    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Colors.black54,
                Colors.black54,
                Colors.black87,
                Colors.black87,
                Colors.black87,
                Colors.black54
              ])),
        ),
        Positioned(
            bottom: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Image.network(
                      'http://pages.ctrip.com/commerce/promote/20180718/yxzy/img/640sygd.jpg',
                      key: const Key("img"),
                      loadingBuilder: (context, child, loadingProgress) {
                        return Container(
                          color: Colors.blue,
                        );
                      },
                      errorBuilder: (context, obj, stackTrace) {
                        return Container(
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                Colors.grey,
                                Colors.grey,
                                Colors.grey,
                                Colors.blueGrey,
                                Colors.grey,
                                Colors.grey
                              ])),
                        );
                      },
                    ),
                    width: MediaQuery.of(context).size.width,
                  )),
                  ShaderMask(
                      shaderCallback: (rect) {
                        // add transparent gradient to lyric top and bottom.
                        return ui.Gradient.linear(
                          Offset(rect.width / 2, 0),
                          Offset(
                            rect.width / 2,
                            MediaQuery.of(context).size.height / 3,
                          ),
                          [
                            Colors.white.withOpacity(0),
                            Colors.white,
                            Colors.white,
                            Colors.white.withOpacity(0.5),
                          ],
                          const [0, 0.15, 0.85, 1],
                        );
                      },
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 3,
                          child: ScrollConfiguration(
                              behavior: EUMNoScrollBehavior(),
                              child: Obx(() => ListView.builder(
                                  controller: controller.listController,
                                  // physics: const BouncingScrollPhysics(),
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  // shrinkWrap: true,
                                  itemCount: controller.dataList.length,
                                  itemBuilder: (context, index) {
                                    return viewItem(controller.dataList[index]);
                                  }))))),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                              padding: const EdgeInsets.only(
                                  left: 5, right: 5, top: 5, bottom: 5),
                              decoration: BoxDecoration(
                                  color: Colors.black26,
                                  borderRadius: BorderRadius.circular(20)),
                              child: const Text(
                                "说点什么",
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                              onTap: () {
                                debugPrint("发送");
                                controller.addData();
                              },
                              child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.black),
                                  child: const Text("发送",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                      )))),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            )),
        Positioned(
            top: 30,
            left: 5,
            child: IconButton(
              iconSize: 30,
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                debugPrint('返回s');
                Get.back();
              },
            )),
      ],
    ));
  }
}

class EUMNoScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
        return child;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return GlowingOverscrollIndicator(
          child: child,
          // 不显示头部水波纹
          showLeading: false,
          // 不显示尾部水波纹
          showTrailing: false,
          axisDirection: axisDirection,
          color: Theme.of(context).accentColor,
        );
      case TargetPlatform.linux:
        break;
      case TargetPlatform.macOS:
        break;
      case TargetPlatform.windows:
        break;
    }
    return child;
  }
}
