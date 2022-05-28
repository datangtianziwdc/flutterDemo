import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var count = 0.obs;
  var count1 = 0.obs;
  var count2 = 0;
  increment() => count++;
  void increment1() {
    count2++;
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    ever(count, (callback) => {debugPrint("callback${callback.toString()}")});
    debounce(count, (callback) => {debugPrint("防抖")});
    // 可以做输入提示
    interval(count, (callback) => {debugPrint("防抖22")});
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    debugPrint("onClose");
  }
}
