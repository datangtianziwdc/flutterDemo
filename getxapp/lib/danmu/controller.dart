import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class DanmuController extends GetxController{
  List dataList = [
    "文字内容1",
    "文字内容2"
  ].obs;
  ScrollController listController = ScrollController();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
  addData(){
    print("更新");
    dataList.add("文字内容");
    listController.animateTo(listController.offset+100, duration: const Duration(milliseconds: 500), curve: Curves.easeInOutSine);
    // update();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
