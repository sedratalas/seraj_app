// import 'package:flutter/material.dart';
// import 'package:seraj_app/core/utils/color_manager.dart';
//
// class TasbeehCounter extends StatefulWidget {
//   const TasbeehCounter({Key? key}) : super(key: key);
//
//   @override
//   State<TasbeehCounter> createState() => _TasbeehCounterState();
// }
//
// class _TasbeehCounterState extends State<TasbeehCounter> {
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.sizeOf(context).width;
//     double screenHeight = MediaQuery.sizeOf(context).height;
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(image: AssetImage("assets/images/splash (1).png",),
//               fit: BoxFit.fill
//           ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             Stack(
//               alignment: Alignment.center,
//               children: [
//                 Image.asset("assets/images/vector.png"),
//                 Image.asset("assets/images/frame.png"),
//                 Text("0",
//                   style: TextStyle(
//                     color: AppColors.darkBrown,
//                     fontWeight: FontWeight.w400,
//                     fontSize: 30,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: screenHeight * (40/800),
//             ),
//             Stack(
//               alignment: Alignment.bottomCenter,
//               children: [
//                 Container(
//                width: screenWidth * (421/360),
//                 height: screenHeight *  (406/800),
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage("assets/images/Ellipse 30.png"),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 ),
//                 Container(
//                   width: screenWidth * (350/360),
//                   height: screenHeight *  (350/800),
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: AssetImage("assets/images/Ellipse 31.png"),
//                       fit: BoxFit.fill,
//                     ),
//                   ),
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       Container(
//                         width: screenWidth * (242/360),
//                         height: screenHeight *  (242/800),
//                         decoration: BoxDecoration(
//                           image: DecorationImage(
//                             image: AssetImage("assets/images/mandala (2) 1.png"),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                       Container(
//                         width: screenWidth * 0.2,
//                         height: screenWidth * 0.2,
//                         decoration: BoxDecoration(
//                           color: AppColors.lightBackground,
//                           shape: BoxShape.circle,
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.2),
//                               spreadRadius: 2,
//                               blurRadius: 5,
//                               offset: Offset(0, 3),
//                             ),
//                           ],
//                         ),
//                         child: Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Image.asset("assets/images/tap 1.png"),
//                               Text(
//                                 "انقر",
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: AppColors.darkBrown,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
/*import 'package:flutter/material.dart';
import 'package:seraj_app/core/utils/color_manager.dart';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seraj_app/providers/theme_notifier.dart';

class TasbeehCounter extends ConsumerStatefulWidget {
  const TasbeehCounter({Key? key}) : super(key: key);

  @override
  ConsumerState<TasbeehCounter> createState() => _TasbeehCounterState();
}

class _TasbeehCounterState extends ConsumerState<TasbeehCounter> {
  final List<int> _numbers = [33, 100, 500, 1000];
  ValueNotifier<double> _rotationAngle = ValueNotifier<double>(0.0);
  ValueNotifier<int> _currentCount = ValueNotifier<int>(0);
  int _selectedNumber = 0;
  Offset? _lastPanPosition;
  final GlobalKey _rotatableWheelKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (_numbers.isNotEmpty) {
      _selectedNumber = _numbers[0];
      _currentCount.value = _selectedNumber;
      _rotationAngle.value = -pi / 2;
    }
  }

  @override
  void dispose() {
    _rotationAngle.dispose();
    _currentCount.dispose();
    super.dispose();
  }

  double _getAngleFromPoint(Offset point, Offset center) {
    final double dx = point.dx - center.dx;
    final double dy = point.dy - center.dy;
    return atan2(dy, dx);
  }

  int _getNumberFromAngle(double currentWheelAngle) {
    final double anglePerNumber = 2 * pi / _numbers.length;

    double normalizedCurrentAngle = (currentWheelAngle % (2 * pi) + (2 * pi)) % (2 * pi);

    double angleFromTop = (normalizedCurrentAngle + pi / 2);
    angleFromTop = (angleFromTop % (2 * pi) + (2 * pi)) % (2 * pi);

    int index = (angleFromTop / anglePerNumber).round() % _numbers.length;

    return _numbers[index];
  }

  List<Widget> _buildRotatableNumbers(double diameter, ValueNotifier<double> rotationAngle) {
    List<Widget> numberWidgets = [];
    final double radius = diameter / 2;
    final double anglePerNumber = 2 * pi / _numbers.length;

    for (int i = 0; i < _numbers.length; i++) {
      final double numberPositionAngle = (-pi / 2) + (anglePerNumber * i);
      final double x = radius * cos(numberPositionAngle);
      final double y = radius * sin(numberPositionAngle);

      numberWidgets.add(
        Positioned(
          left: radius + x - (24 / 2),
          top: radius + y - (24 / 2),
          child: ValueListenableBuilder<double>(
            valueListenable: rotationAngle,
            builder: (context, angle, child) {
              return Transform.rotate(
                angle: -angle,
                child: Text(
                  _numbers[i].toString(),
                  style: TextStyle(
                    fontSize: 24,
                    color: _selectedNumber == _numbers[i] ? AppColors.darkBrown : Colors.black,
                    fontWeight: _selectedNumber == _numbers[i] ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              );
            },
          ),
        ),
      );
    }
    return numberWidgets;
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeNotifierProvider);

    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    final double outerWheelDiameter = screenWidth * (421 / 360);
    final double innerFixedDiameter = screenWidth * (350 / 360);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(themeState.currentBackgroundImage),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SizedBox(height: screenHeight * 0.05),
                Text(
                  "سبحان الله وبحمده",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.darkBrown),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  "سبحان الله العظيم",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.darkBrown),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * (40 / 800)),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset("assets/images/vector.png", width: screenWidth * 0.25, height: screenWidth * 0.25),
                    Image.asset("assets/images/frame.png", width: screenWidth * 0.2, height: screenWidth * 0.2),
                    ValueListenableBuilder<int>(
                      valueListenable: _currentCount,
                      builder: (context, count, child) {
                        return Text(
                          count.toString(),
                          style: TextStyle(
                            color: AppColors.darkBrown,
                            fontWeight: FontWeight.w400,
                            fontSize: 30,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            GestureDetector(
              onPanStart: (details) {
                if (_rotatableWheelKey.currentContext != null) {
                  final RenderBox renderBox = _rotatableWheelKey.currentContext!.findRenderObject() as RenderBox;
                  final Offset wheelCenter = renderBox.size.center(Offset.zero);
                  _lastPanPosition = renderBox.globalToLocal(details.globalPosition) - wheelCenter;
                }
              },
              onPanUpdate: (details) {
                if (_lastPanPosition == null || _rotatableWheelKey.currentContext == null) return;

                final RenderBox renderBox = _rotatableWheelKey.currentContext!.findRenderObject() as RenderBox;
                final Offset wheelCenter = renderBox.size.center(Offset.zero);
                final Offset currentPanPosition = renderBox.globalToLocal(details.globalPosition) - wheelCenter;

                double prevAngle = _getAngleFromPoint(_lastPanPosition!, Offset.zero);
                double currentAngle = _getAngleFromPoint(currentPanPosition, Offset.zero);

                double angleDelta = currentAngle - prevAngle;

                _rotationAngle.value += angleDelta;

                setState(() {
                  _selectedNumber = _getNumberFromAngle(_rotationAngle.value);
                  _currentCount.value = _selectedNumber;
                });

                _lastPanPosition = currentPanPosition;
              },
              onPanEnd: (details) {
                _lastPanPosition = null;
                final double anglePerNumber = 2 * pi / _numbers.length;
                double normalizedAngle = (_rotationAngle.value % (2 * pi) + (2 * pi)) % (2 * pi);
                double targetAngle = (normalizedAngle / anglePerNumber).round() * anglePerNumber;
                _rotationAngle.value = targetAngle;

                setState(() {
                  _selectedNumber = _getNumberFromAngle(_rotationAngle.value);
                  _currentCount.value = _selectedNumber;
                });
              },
              child: ValueListenableBuilder<double>(
                valueListenable: _rotationAngle,
                builder: (context, angle, child) {
                  return Transform.rotate(
                    angle: angle,
                    alignment: Alignment.center,
                    child: Stack(
                      key: _rotatableWheelKey,
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: outerWheelDiameter,
                          height: outerWheelDiameter,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/Ellipse 30.png"),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        ..._buildRotatableNumbers(outerWheelDiameter, _rotationAngle),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              width: innerFixedDiameter,
              height: innerFixedDiameter,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/Ellipse 31.png"),
                  fit: BoxFit.fill,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    "assets/images/mandala (2) 1.png",
                    width: screenWidth * (242 / 360),
                    height: screenHeight * (242 / 800),
                    fit: BoxFit.cover,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_currentCount.value > 0) {
                        _currentCount.value--;
                      } else if (_selectedNumber > 0) {
                        _currentCount.value = _selectedNumber;
                      }
                    },
                    child: Container(
                      width: screenWidth * 0.2,
                      height: screenWidth * 0.2,
                      decoration: BoxDecoration(
                        color: AppColors.lightBackground,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/images/tap 1.png", width: screenWidth * 0.08, height: screenWidth * 0.08),
                            Text(
                              "انقر",
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.darkBrown,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
          ],
        ),
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/theme_notifier.dart';
import '../core/utils/color_manager.dart';
class TasbeehCounter extends ConsumerStatefulWidget {
  const TasbeehCounter({Key? key}) : super(key: key);

  @override
  ConsumerState<TasbeehCounter> createState() => _TasbeehCounterState();
}

class _TasbeehCounterState extends ConsumerState<TasbeehCounter> {
  @override
  Widget build(BuildContext context) {
        double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
        final themeState = ref.watch(themeNotifierProvider);
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(themeState.currentBackgroundImage),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset("assets/images/vector.png"),
                Image.asset("assets/images/frame.png"),
                Text("0",
                  style: TextStyle(
                    color: AppColors.darkBrown,
                    fontWeight: FontWeight.w400,
                    fontSize: 30,
                  ),
                ),
              ],
            ),
                SizedBox(
                  height: screenHeight * (40/800),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: screenWidth * (421/360),
                      height: screenHeight *  (406/800),
                      decoration: BoxDecoration(
                        color: AppColors.lightBackground,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      width: screenWidth * (294/360),
                      height: screenHeight *  (284/800),
                      decoration: BoxDecoration(
                        color: Color(0xffE2CEA2),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                        width: screenWidth * (242/360),
                        height: screenHeight *  (242/800),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/mandala (2) 1.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    Container(
                        width: screenWidth * 0.2,
                        height: screenWidth * 0.2,
                        decoration: BoxDecoration(
                          color: AppColors.lightBackground,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/images/tap 1.png"),
                              Text(
                                "انقر",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.darkBrown,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                               ],
                            ),
                        ),
                    ),
              ],
            ),
          ],
          ),
        ),
      ),
    );
  }
}
