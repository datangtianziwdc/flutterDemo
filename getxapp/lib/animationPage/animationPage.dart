import 'dart:math';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class AnimationPage extends StatefulWidget {
  const AnimationPage({Key? key}) : super(key: key);

  @override
  State<AnimationPage> createState() => _AnimationPageState();
}

class _AnimationPageState extends State<AnimationPage>
    // with SingleTickerProviderStateMixin {
    with
        TickerProviderStateMixin {
  final ValueNotifier<double> _height = ValueNotifier<double>(40);
  final ValueNotifier<bool> _switch = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _opacity = ValueNotifier<bool>(false);
  final ValueNotifier<double> _tweenRotate = ValueNotifier<double>(6.28);
  final ValueNotifier<double> _tweenTranslate = ValueNotifier<double>(-10);
  final ValueNotifier<double> _currentCount = ValueNotifier<double>(5.0);
  final ValueNotifier<String> switchName = ValueNotifier<String>("day_idle");
  late final AnimationController _turnsController;
  late final AnimationController _tweenController;
  late final AnimationController _breatheController;
  late final AnimationController _snowController;
  final List<Snowflake> _snowflakes =
      List.generate(1000, (index) => Snowflake());
  @override
  void initState() {
    _turnsController = AnimationController(
      duration: const Duration(milliseconds: 1000), vsync: this,
      // upperBound: 0.5, 动画下限
      // lowerBound: 1,  动画上限
    );
    // ..repeat()  回传本身
    _tweenController = AnimationController(
      duration: const Duration(milliseconds: 1000), vsync: this,
      // upperBound: 0.5, 动画下限
      // lowerBound: 1,  动画上限
    );
    _breatheController = AnimationController(
      duration: const Duration(milliseconds: 1000), vsync: this,
      // upperBound: 0.5, 动画下限
      // lowerBound: 1,  动画上限
    );
    _snowController = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: this,
    )..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _turnsController.dispose();
    _tweenController.dispose();
    _breatheController.dispose();
    _snowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ValueListenableBuilder(
              valueListenable: _height,
              builder: (context, value, child) {
                debugPrint("ValueListenableBuilder---带动画的盒子");
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  height: _height.value,
                  width: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      _height.value == 40.0
                          ? _height.value = 50.0
                          : _height.value = 40.0;
                      debugPrint("_height---${_height.toString()}");
                    },
                    child: Text("带动画的盒子" + value.toString()),
                  ),
                );
              }),
          ValueListenableBuilder(
              valueListenable: _switch,
              builder: (context, value, child) {
                debugPrint("ValueListenableBuilder---动画切换元素");
                return AnimatedSwitcher(
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(
                        scale: animation,
                        child: child,
                      ),
                    );
                  },
                  duration: const Duration(milliseconds: 500),
                  child: ElevatedButton(
                    key: UniqueKey(),
                    onPressed: () {
                      _switch.value = !_switch.value;
                    },
                    child: Text(
                      "动画切换元素${_switch.value.toString()}",
                    ),
                  ),
                );
              }),
          ValueListenableBuilder(
              valueListenable: _opacity,
              builder: (context, value, child) {
                debugPrint("ValueListenableBuilder---淡入淡出");
                return AnimatedOpacity(
                  opacity: _opacity.value ? 1.0 : 0.2,
                  curve: Curves.easeIn,
                  duration: const Duration(milliseconds: 500),
                  child: ElevatedButton(
                    onPressed: () {
                      _opacity.value = !_opacity.value;
                    },
                    child: const Text(
                      "淡入淡出",
                    ),
                  ),
                );
              }),
          ValueListenableBuilder(
              valueListenable: _tweenRotate,
              builder: (context, value, child) {
                debugPrint("ValueListenableBuilder---旋转补间");
                return TweenAnimationBuilder(
                    tween: Tween(begin: 0.0, end: _tweenRotate.value),
                    duration: const Duration(milliseconds: 500),
                    builder: (ctx, double value, child) {
                      return SizedBox(
                        height: 40,
                        child: Transform.rotate(
                          angle: value,
                          child: ElevatedButton(
                            onPressed: () {
                              _tweenRotate.value == 6.28
                                  ? _tweenRotate.value = 0.0
                                  : _tweenRotate.value = 6.28;
                            },
                            child: const Text(
                              "旋转补间",
                            ),
                          ),
                        ),
                      );
                    });
              }),
          ValueListenableBuilder(
              valueListenable: _tweenTranslate,
              builder: (context, value, child) {
                debugPrint("ValueListenableBuilder---偏移补间");
                return TweenAnimationBuilder(
                    tween: Tween(begin: 0.0, end: _tweenTranslate.value),
                    duration: const Duration(milliseconds: 500),
                    builder: (ctx, double value, child) {
                      return SizedBox(
                        height: 40,
                        child: Transform.translate(
                          offset: Offset(value, 0),
                          child: ElevatedButton(
                            onPressed: () {
                              _tweenTranslate.value == -10.0
                                  ? _tweenTranslate.value = 0.0
                                  : _tweenTranslate.value = -10.0;
                            },
                            child: const Text(
                              "偏移补间",
                            ),
                          ),
                        ),
                      );
                    });
              }),
          ValueListenableBuilder(
              valueListenable: _currentCount,
              builder: (context, value, child) {
                debugPrint("ValueListenableBuilder---计数器");
                return TweenAnimationBuilder(
                    tween: Tween(begin: 1.0, end: _currentCount.value),
                    duration: const Duration(milliseconds: 500),
                    builder: (ctx, double value, child) {
                      final whole = value ~/ 1; // 取整数部分
                      final decimal = value - whole;
                      return Container(
                        color: Colors.blue,
                        height: 40,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                                top: -100 * decimal + 5, // 0 -> -100
                                child: Opacity(
                                    opacity: 1 - decimal,
                                    child: Text("$whole",
                                        style: const TextStyle(
                                            color: Colors.white)))),
                            Positioned(
                                top: 100 * (1.0 - decimal) + 5,
                                child: Opacity(
                                    opacity: decimal,
                                    child: Text("${whole + 1}",
                                        style: const TextStyle(
                                            color: Colors.white)))),
                            Positioned(
                                left: 50,
                                child: IconButton(
                                  icon: const Icon(Icons.remove_circle,
                                      color: Colors.white),
                                  onPressed: () {
                                    _currentCount.value--;
                                  },
                                )),
                            Positioned(
                                right: 50,
                                child: IconButton(
                                  icon: const Icon(Icons.add_circle,
                                      color: Colors.white),
                                  onPressed: () {
                                    _currentCount.value++;
                                  },
                                ))
                          ],
                        ),
                      );
                    });
              }),
          ValueListenableBuilder(
              valueListenable: _currentCount,
              builder: (context, value, child) {
                debugPrint("ValueListenableBuilder---显式动画控制器");
                return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      RotationTransition(
                          turns: _turnsController,
                          child: const Icon(
                            Icons.refresh_sharp,
                          )),
                      FadeTransition(
                          opacity: _turnsController,
                          child: const Icon(
                            Icons.adb,
                          )),
                      ScaleTransition(
                          scale: _turnsController,
                          child: const Icon(Icons.sms_outlined)),
                      ElevatedButton(
                          onPressed: () {
                            debugPrint("${_turnsController.status}");
                            if (_turnsController.status ==
                                AnimationStatus.dismissed) {
                              _turnsController.repeat(reverse: true);
                            } else if (_turnsController.status ==
                                AnimationStatus.forward) {
                              _turnsController.reset();
                            }
                          },
                          child: const Text(
                            "显式动画控制器",
                          ))
                    ]);
              }),
          ValueListenableBuilder(
              valueListenable: _tweenController,
              builder: (context, value, child) {
                debugPrint("ValueListenableBuilder---串联补间动画");
                return Stack(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: SlideTransition(
                          position: Tween(
                                  begin: const Offset(0.0, 0.0),
                                  end: const Offset(5.0, 1.0))
                              // .chain(CurveTween(curve: Curves.elasticInOut))
                              .chain(
                                  CurveTween(curve: const Interval(0.0, 0.5)))
                              .animate(_tweenController),
                          child: const Icon(Icons.android_sharp)),
                    ),
                    Positioned(
                        right: 0,
                        child: ElevatedButton(
                            onPressed: () {
                              debugPrint("${_tweenController.status}");
                              if (_tweenController.status ==
                                  AnimationStatus.dismissed) {
                                _tweenController.repeat(reverse: true);
                              } else if (_tweenController.status ==
                                  AnimationStatus.forward) {
                                _tweenController.reset();
                              } else if (_tweenController.status ==
                                  AnimationStatus.reverse) {
                                _tweenController.reset();
                              }
                            },
                            child: const Text(
                              "串联补间动画",
                            )))
                  ],
                );
              }),
          ValueListenableBuilder(
              valueListenable: _breatheController,
              builder: (context, value, child) {
                debugPrint("ValueListenableBuilder---串联补间动画");
                return AnimatedBuilder(
                    animation: _breatheController,
                    builder: (context, widget) {
                      return InkWell(
                          onTap: () {
                            if (_breatheController.status ==
                                AnimationStatus.dismissed) {
                              _breatheController.repeat(reverse: true);
                            } else {
                              _breatheController.reset();
                            }
                          },
                          child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue,
                                  gradient: RadialGradient(colors: const [
                                    Colors.lightBlue,
                                    Colors.blue
                                  ], stops: [
                                    _breatheController.value,
                                    _breatheController.value + 0.1
                                  ]))));
                    });
              }),
          Hero(
              tag: "tag",
              child: InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Hero动画在不同页面的tag要一致才有效果'),
                    // action: SnackBarAction(
                    //   label: '点击重试',
                    //   onPressed: () {
                    //     //执行相关逻辑
                    //   },
                    // ),
                  ));
                },
                child: Container(
                    height: 50,
                    width: 50,
                    color: Colors.blue,
                    child: const Center(child: Text("Hero动画"))),
              )),
          Center(
              child: AnimatedBuilder(
            animation: _snowController,
            builder: (_, __) {
              // debugPrint("动画正在渲染");
              for (var item in _snowflakes) {
                item.fall();
              }
              return Container(
                // constraints: const BoxConstraints.expand(),
                width: 300,
                height: 300,
                decoration: const BoxDecoration(
                    color: Colors.blue,
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.blue, Colors.lightBlue, Colors.white],
                        stops: [0.0, 0.3, 1.0])),
                child: CustomPaint(
                  painter: MyPainter(_snowflakes),
                ),
              );
            },
          )),
          ValueListenableBuilder(
              valueListenable: switchName,
              builder: (context, value, child) {
                debugPrint("ValueListenableBuilder---flr动画");
                return AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    color: switchName.value == "day_idle" ||
                            switchName.value == "switch_day"
                        ? Colors.white
                        : Colors.black,
                    child: Center(
                        child: InkWell(
                            child: SizedBox(
                              height: 50,
                              width: 100,
                              child: FlareActor(
                                "assets/switch_daytime.flr",
                                alignment: Alignment.center,
                                fit: BoxFit.contain,
                                animation: switchName.value,
                                callback: (name) {
                                  debugPrint("动画名$name");
                                  if (switchName.value == "switch_day") {
                                    switchName.value = "day_idle";
                                  } else if (switchName.value ==
                                      "switch_night") {
                                    switchName.value = "night_idle";
                                  }
                                },
                              ),
                            ),
                            onTap: () {
                              debugPrint("点击动画名：$switchName");
                              if (switchName.value == "day_idle") {
                                switchName.value = "switch_night";
                              } else if (switchName.value == "night_idle") {
                                switchName.value = "switch_day";
                              }
                            })));
              })
        ],
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  final List<Snowflake> _snowflake;
  MyPainter(this._snowflake);

  @override
  void paint(Canvas canvas, Size size) {
    // debugPrint("size----$size");
    final whitePaint = Paint()..color = Colors.white;
    // canvas.drawCircle(Offset(size.width/2,size.height/2), 20.0, Paint());
    canvas.drawCircle(size.center(const Offset(0, -80)), 50, whitePaint);
    canvas.drawOval(
        Rect.fromCenter(
            center: size.center(const Offset(0, 80)), width: 200, height: 250),
        whitePaint);
    for (var element in _snowflake) {
      canvas.drawCircle(
          Offset(element.x, element.y), element.radius, whitePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Snowflake {
  double x = Random().nextDouble() * 360;
  double y = Random().nextDouble() * 300;
  double radius = Random().nextDouble() * 2 + 2;
  double velocity = Random().nextDouble() * 4 + 2;
  fall() {
    y += velocity;
    // debugPrint("fall执行$y");
    if (y > 300) {
      y = 0;
      x = Random().nextDouble() * 360;
      radius = Random().nextDouble() * 2 + 2;
      velocity = Random().nextDouble() * 4 + 2;
    }
  }
}
