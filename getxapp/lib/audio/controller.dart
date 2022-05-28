import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:on_audio_edit/on_audio_edit.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Controller extends GetxController{
  // OnAudioQuery instance
  OnAudioQuery audioQuery = OnAudioQuery();
  // OnAudioQuery instance
  OnAudioEdit audioEdit = OnAudioEdit();
  // Texts controllers
  TextEditingController name = TextEditingController();
  TextEditingController artist = TextEditingController();

  // Main parameters
  List<SongModel> songList = [];
  bool? result;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    requestPermission();
  }

  requestPermission() async {
    bool permissionStatus = await audioQuery.permissionsStatus();
    if (!permissionStatus) {
      await audioQuery.permissionsRequest();
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    debugPrint("onClose");
  }
}
