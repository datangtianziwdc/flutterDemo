import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getxapp/audio/controller.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';

class AudioPage extends StatelessWidget {
  const AudioPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Controller(), tag: "audioPageController");
    String _htmlFile = "/storage/emulated/0/yizhibo/download/a.xls";
    Future<File> _getLocalFile() async {
    // get the path to the document directory.
    // String dir = (await getApplicationDocumentsDirectory()).path;
    // String dir = (await getExternalStorageDirectory()).path;
    // _htmlFile = dir + '/counter.html';
    // print(
    //   '文件路径$dir/counter.html',
    // );
    String dir = (await getExternalStorageDirectory())!.path;
    _htmlFile = dir + '/a.xls';
    print(
      '文件路径$dir/a.xls',
    );
    // return new File('$dir/counter.txt');
    // return File('$dir/a.xls');
    return File('$dir/a.xls');
  }
    Future<int> _readCounter() async {
      try {
        File file = await _getLocalFile();
        print("file===${file.toString()}");
        // read the variable as a string from the file.
        print("file.readAsString();==${file.readAsBytesSync()}");
        // String contents = await file.readAsString();
        // print('文件contents${contents.toString()}');
        // return int.parse(contents);
        return 0;
      } on FileSystemException {
        return 0;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Songs"),
        elevation: 2,
      ),
      body: Stack(
        children: [
          FutureBuilder<List<SongModel>>(
            future: controller.audioQuery.querySongs(),
            builder: (context, item) {
              // Loading content
              if (item.data == null) return const CircularProgressIndicator();

              // When you try "query" without asking for [READ] or [Library] permission
              // the plugin will return a [Empty] list.
              if (item.data!.isEmpty) return const Text("Nothing found!");

              controller.songList = item.data!;
              return RefreshIndicator(
                onRefresh: () async {},
                child: ListView.builder(
                  itemCount: controller.songList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      // [onTap] will open a dialog with two options:
                      //
                      // * Edit audio tags.
                      // * Edit audio artwork.
                      onTap: () async {
                        {
                          // Get.back(closeOverlays: true),
                          Get.snackbar(
                            controller.songList[index].title,
                            controller.songList[index].artist.toString() +
                                "路径" +
                                controller.songList[index].uri.toString(),
                            // controller.songList[index].uri.toString() +
                            // controller.songList[index].album.toString(),
                            colorText: Colors.white,
                            backgroundColor: Colors.black54,
                            duration: const Duration(milliseconds: 5000),
                            snackPosition: SnackPosition.BOTTOM,
                          );
                          // debugPrint(File(controller.songList[index].uri.toString()).readAsStringSync().toString()),
                          // debugPrint(
                          //     controller.songList[index].data.toString());
                          debugPrint(
                              "歌曲信息:${controller.songList[index].data.toString()}");
                          debugPrint(
                              "歌曲信息:${controller.songList[index].uri.toString()}");
                          debugPrint(
                              "歌曲信息:${controller.songList[index].displayName.toString()}");
                          debugPrint(
                              "歌曲信息:${controller.songList[index].displayNameWOExt.toString()}");
                          debugPrint(
                              "歌曲信息:${controller.songList[index].size.toString()}");
                          debugPrint(
                              "歌曲信息:${controller.songList[index].album.toString()}");
                          debugPrint(
                              "歌曲信息:${controller.songList[index].albumId.toString()}");
                          debugPrint(
                              "歌曲信息:${controller.songList[index].artist.toString()}");
                          debugPrint(
                              "歌曲信息:${controller.songList[index].artistId.toString()}");
                          debugPrint(
                              "歌曲信息:${controller.songList[index].genre.toString()}");
                          debugPrint(
                              "歌曲信息:${controller.songList[index].genreId.toString()}");
                          debugPrint(
                              "歌曲信息:${controller.songList[index].bookmark.toString()}");
                          debugPrint(
                              "歌曲信息:${controller.songList[index].composer.toString()}");
                          debugPrint(
                              "歌曲信息:${controller.songList[index].dateAdded.toString()}");
                          debugPrint(
                              "歌曲信息:${controller.songList[index].dateModified.toString()}");
                          debugPrint(
                              "歌曲信息:${controller.songList[index].duration.toString()}");
                          debugPrint(
                              "歌曲信息:${controller.songList[index].title.toString()}");
                          debugPrint(
                              "歌曲信息:${controller.songList[index].track.toString()}");
                          debugPrint(
                              "歌曲信息:${controller.songList[index].fileExtension.toString()}");
                          debugPrint(
                              "歌曲信息:${controller.songList[index].isAlarm.toString()}");
                          debugPrint(
                              "歌曲信息:${controller.songList[index].isAudioBook.toString()}");
                          debugPrint(
                              "歌曲信息:${controller.songList[index].isMusic.toString()}");
                          debugPrint(
                              "歌曲信息:${controller.songList[index].isNotification.toString()}");
                          debugPrint(
                              "歌曲信息:${controller.songList[index].isPodcast.toString()}");
                          debugPrint(
                              "歌曲信息:${controller.songList[index].isRingtone.toString()}");
                          debugPrint(
                              "歌曲信息:${controller.songList[index].getMap.toString()}");
                          // yizhibo/download/zs7z5dGj7iQbk5Hre5Nw.mp3
                          // Directory dir = Directory(
                          //     "/storage/emulated/0/yizhibo/download/");
                          // debugPrint("dir==${dir.toString()}");
                          debugPrint(File(controller.songList[index].data.toString())
                              .readAsBytesSync()
                              .toString());
                          // List<FileSystemEntity> _files =
                          //     dir.listSync(recursive: true, followLinks: false);
                          // // String contents = await File(dir).readAsString();
                          // debugPrint("_files==${_files.toString()}");
                          // _readCounter();
                          // Uri encryptedBase64EncodedString =
                          //     Uri.file(_files[0].path);
                          // debugPrint(
                          //     "encryptedBase64EncodedString==${encryptedBase64EncodedString.toString()}");
                          //     debugPrint(File(encryptedBase64EncodedString.path)
                          //     .readAsStringSync()
                          //     .toString());
                          // debugPrint(encryptedBase64EncodedString.toString());
                          // debugPrint(File(controller.songList[index].uri.toString()).path.toString())
                        }
                      },
                      // [onLongPress] will read all information about selected items:
                      title: Text(controller.songList[index].title),
                      subtitle: Text(
                        controller.songList[index].artist ?? '<No artist>',
                      ),
                      trailing: const Icon(Icons.arrow_forward_rounded),
                      leading: QueryArtworkWidget(
                        id: controller.songList[index].id,
                        type: ArtworkType.AUDIO,
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
