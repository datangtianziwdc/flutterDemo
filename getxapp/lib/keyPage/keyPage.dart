import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KeyPage extends StatefulWidget {
  const KeyPage({Key? key}) : super(key: key);

  @override
  State<KeyPage> createState() => _KeyPageState();
}

class _KeyPageState extends State<KeyPage> {
  final boxes = [
    const Box(Colors.blue, key: ValueKey("1")),
    const Box(Colors.lightBlue, key: ValueKey("2")),
    const Box(Colors.lightBlueAccent, key: ValueKey("3"))
  ];
  final _globalKey = GlobalKey();
  late double _offset;
  late int slot;
  List<Color> colors = [];
  var _color = Colors.blue;
  @override
  initState(){
    super.initState();
    _shuffle();
  }
  // 打乱
  _shuffle() {
    _color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    colors = List.generate(6, (index) => _color[(index+1)*100]!);
    setState(() {
      colors.shuffle();
      boxes.shuffle();
    });
  }
  // 洗牌
  _checkWinCondition(){
    // 通过亮度检查当前排序
    debugPrint("_checkWinCondition${colors.map((e) => e.computeLuminance()).toList()}");
    List<double> lum = colors.map((e) => e.computeLuminance()).toList();
    bool sucess = true;
    for(int i=0;i<lum.length-1;i++){
      if(lum[i] > lum[i+1]){
        sucess = false;
        break;
      }
    }
    if(sucess){
      Get.defaultDialog(title: "提示",content:const Text("恭喜你赢了！"));
    }
    debugPrint(sucess?"win":"");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("KEY"),
          actions: [
            IconButton(
                onPressed: () {
                  _shuffle();
                },
                icon: const Icon(Icons.refresh_outlined))
          ]
        ),
        body: Center(
            child: Column(children: [
          SizedBox(
              height: 200,
              child: ReorderableListView(
                onReorder: (int oldIndex, int newIndex) {
                  debugPrint("oldIndex$oldIndex   newIndex$newIndex");
                  if (newIndex > oldIndex) newIndex--;
                  final box = boxes.removeAt(oldIndex);
                  boxes.insert(newIndex, box);
                },
                children: boxes,
              )),
          const SizedBox(height: 20),
          const Text("颜色从深到浅排序", style: TextStyle(fontSize: 20)),
          const SizedBox(height: 20),
          SizedBox(
              width: DragBox.width - 3 * DragBox.margin,
              child: Container(
                height: DragBox.height - 2 * DragBox.margin,
                decoration: BoxDecoration(
                    color: _color[900],
                    borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.lock_outline,color: Colors.white),
              )),
          const SizedBox(height: DragBox.margin * 2),
          SizedBox(
              width: DragBox.width,
              height: colors.length * DragBox.height,
              child: Listener(
                onPointerMove: (event) {
                  // debugPrint("监听事件$event");
                  // debugPrint("事件${slot * DragBox.width}");

                  // final x = event.position.dx;
                  // if (x > (slot + 1) * DragBox.width) {
                  //   if(slot == colors.length-1)return;
                  //   setState(() {
                  //     final c = colors[slot];
                  //     colors[slot] = colors[slot + 1];
                  //     colors[slot + 1] = c;
                  //     slot ++;
                  //   });
                  // }else if(x < slot * DragBox.width) {
                  //   if(slot == 0)return;
                  //   setState(() {
                  //     final c = colors[slot];
                  //     colors[slot] = colors[slot-1];
                  //     colors[slot-1] = c;
                  //     slot --;
                  //   });
                  // }
                  final y = event.position.dy - _offset;
                  if (y > (slot + 1) * DragBox.height) {
                    if (slot == colors.length - 1) return;
                    setState(() {
                      final c = colors[slot];
                      colors[slot] = colors[slot + 1];
                      colors[slot + 1] = c;
                      slot++;
                    });
                  } else if (y < slot * DragBox.height) {
                    if (slot == 0) return;
                    setState(() {
                      final c = colors[slot];
                      colors[slot] = colors[slot - 1];
                      colors[slot - 1] = c;
                      slot--;
                    });
                  }
                },
                child: Stack(
                    key: _globalKey,
                    children: List.generate(
                        colors.length,
                        (i) => DragBox(
                              color: colors[i],
                              x: 0,
                              y: i * DragBox.height,
                              onDrag: (Color color) {
                                final renderBox = (_globalKey.currentContext!
                                    .findRenderObject() as RenderBox);
                                _offset =
                                    renderBox.localToGlobal(Offset.zero).dy;
                                final index = colors.indexOf(color);
                                slot = index;
                                debugPrint("on Drag $index---$i---$_offset");
                              },
                              onEnd: _checkWinCondition,
                              key: ValueKey(colors[i]),
                            ))),
              ))
        ])));
  }
}

class Box extends StatelessWidget {
  final Color color;

  const Box(this.color, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      color: color,
    );
  }
}

class DragBox extends StatelessWidget {
  static const width = 200.0;
  static const height = 50.0;
  static const margin = 2.0;
  final Color color;
  final double x;
  final double y;
  final Function(Color) onDrag;
  final Function() onEnd;

  const DragBox(
      {required this.color,
      required this.x,
      required this.y,
      required this.onDrag,
      required this.onEnd,
      Key? key, })
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final container = Container(
      width: width - 2 * margin,
      height: height - 2 * margin,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
    );
    return AnimatedPositioned(
        left: x,
        top: y,
        child: Draggable(
          child: container,
          feedback: container,
          childWhenDragging: Visibility(
            visible: false,
            child: container,
          ),
          onDragStarted: () => onDrag(color),
          onDragEnd: (_)=>onEnd(),
        ),
        duration: const Duration(milliseconds: 300));
  }
}
