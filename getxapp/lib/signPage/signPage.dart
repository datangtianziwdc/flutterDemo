import 'dart:typed_data';
import 'dart:ui' as ui show ImageByteFormat, Image,window;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

const double STROKEWIDTH = 8;

/// 一张画布，可以跟随手指画线  例如用来做电子签名
class SignPage extends StatefulWidget {
  const SignPage({Key? key}) : super(key: key);

  @override
  State<SignPage> createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  List<Offset> _points = <Offset>[];
  GlobalKey? globalKey;

  String? imageLocalPath;
  Function? noSign;
  double mStrokeWidth = 1.0;

  @override
  void initState() {
    super.initState();
    //横屏
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    globalKey = GlobalKey();
  }

  @override
  void dispose() {
    //竖屏
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.dispose();
  }

  Future<File> _saveImageToFile() async {
    Directory tempDir = await getTemporaryDirectory();
    // Directory tempDir = await getExternalStorageDirectory();
    int curT = DateTime.now().millisecondsSinceEpoch;
    String toFilePath = "${tempDir.path}/$curT.png";
    File file = File(toFilePath);
    bool exists = await file.exists();
    if (!exists) {
      await file.create(recursive: true);
    }
    return file;
  }

  Future<String> _capturePng(File file) async {
    //1.获取RenderRepaintBoundary
    RenderRepaintBoundary boundary =
        globalKey!.currentContext!.findRenderObject() as RenderRepaintBoundary;
        debugPrint("设备比例:${ui.window.devicePixelRatio}");
    //2.生成Image
    ui.Image image = await boundary.toImage(pixelRatio: ui.window.devicePixelRatio);
    //3.生成 Unit8List
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    //4.本地存储Image
    file.writeAsBytes(pngBytes);
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: signWidget());
  }

  Widget signWidget() {
    return RepaintBoundary(
      key: globalKey,
      child: Container(
        child: Stack(
          children: <Widget>[
            Positioned.fill(
                child: Container(
              child: CustomPaint(
                painter: SignatuePainter(_points, mStrokeWidth),
              ),
              color: Colors.white,
            )),
            GestureDetector(
              onPanUpdate: (DragUpdateDetails details) {
                debugPrint("绘制:${details.delta}");
                RenderBox renderBox = context.findRenderObject() as RenderBox;
                Offset localPosition =
                    renderBox.globalToLocal(details.globalPosition);
                RenderBox referenceBox =
                    globalKey!.currentContext!.findRenderObject() as RenderBox;

                //校验范围，防止超过外面
                if (localPosition.dx <= 0 || localPosition.dy <= 0) return;
                if (localPosition.dx > referenceBox.size.width ||
                    localPosition.dy > referenceBox.size.height) return;

                setState(() {
                  _points = List.from(_points)..add(localPosition);
                });
              },
              onPanEnd: (DragEndDetails details) {
                _points.add(Offset.zero);
              },
            ),
            Positioned(
                right: 20,
                top: 0,
                bottom: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _points.clear();
                            _points = [];
                            imageLocalPath = null;
                          });
                        },
                        child: const Text("重写")),
                    ElevatedButton(onPressed: () async {
                       if(_points != Offset.zero && _points.isNotEmpty){
                          File file = await _saveImageToFile();
                          String toPath = await _capturePng(file);
                          debugPrint("path:${file.path}");
                          setState(() {
                            imageLocalPath = toPath;
                          });
                        }else{
                          debugPrint("没有签名");
                        }
                    }, child: const Text("保存"))
                  ],
                ))

            // Image.file(
            //   File(_imageLocalPath ?? ""),
            //   height: 100,
            //   width: 100,
            // )
          ],
        ),
      ),
    );
  }
}

class SignatuePainter extends CustomPainter {
  final List<Offset> points;
  double mStrokeWidth;

  SignatuePainter(this.points, this.mStrokeWidth);

  @override
  void paint(Canvas canvas, Size size) {
    if (mStrokeWidth == 0) {
      mStrokeWidth = STROKEWIDTH;
    }
    Paint paint = Paint()
      ..strokeCap = StrokeCap.round
      ..color = Colors.black
      ..isAntiAlias = true
      ..strokeWidth = mStrokeWidth;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.zero && points[i + 1] != Offset.zero) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(SignatuePainter oldDelegate) {
    return points != oldDelegate.points;
  }
}
