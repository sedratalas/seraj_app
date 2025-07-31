
import 'dart:math';
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
  double _rotationAngle = 0.0;
  int? _selectedValue;
  int _currentCount = 0;

  final List<int> _numbers = [3, 7, 10, 33, 100, 500, 1000];

  final List<String> azkarList = [
    "سبحان الله وبحمده",
    "سبحان الله العظيم",
    "اللهم صل على سيدنا محمد",
    "لا حول ولا قوة إلا بالله",
    "لا إله إلا الله",
    "استغفر الله",
  ];

  final int _initialPage = 10000;
  late PageController _pageController;
  int _currentZikrIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.6,
      initialPage: _initialPage,
    );
    _currentZikrIndex = _initialPage % azkarList.length;
  }

  void _updateSelectedValue() {
    final double angleStep = 2 * pi / _numbers.length;
    int index = ((_rotationAngle + pi / 2) / angleStep).round() % _numbers.length;
    setState(() {
      _selectedValue = _numbers[index];
      _currentCount = _selectedValue!;
    });
  }

  void _decreaseCount() {
    if (_currentCount > 0) {
      setState(() {
        _currentCount--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    final themeState = ref.watch(themeNotifierProvider);

    return Scaffold(
      body: Container(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(themeState.currentLeftFloralImage),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("سراج", style: TextStyle(fontSize: 30,color: themeState.sirajTextColor, fontFamily: "H-ALHFHAF",),),
                  ),
                  Image.asset(themeState.currentRightFloralImage),
                ],
              ),
              SizedBox(height: 15,),
              SizedBox(
                height: 150,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentZikrIndex = index % azkarList.length;
                    });
                  },
                  itemBuilder: (context, index) {
                    final realIndex = index % azkarList.length;
                    final isSelected = realIndex == _currentZikrIndex;
                    return AnimatedContainer(
                      height: 150,
                      width: 300,
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: isSelected ? 10 : 20),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.darkBrown.withOpacity(isSelected ? 0.9 : 0.4),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          azkarList[realIndex],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily:  "H-ALHFHAF",
                            fontSize: isSelected ? 20 : 16,
                            color: Colors.white,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 4,),
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset("assets/images/vector.png"),
                  Image.asset("assets/images/frame.png"),
                  Text(
                    _currentCount.toString(),
                    style: TextStyle(
                      color: AppColors.darkBrown,
                      fontWeight: FontWeight.w400,
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * (41 / 800)),
              GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _rotationAngle += details.delta.dx * 0.01;
                    _updateSelectedValue();
                  });
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.rotate(
                      angle: _rotationAngle,
                      child: Container(
                        width: screenWidth * (421 / 360),
                        height: screenHeight * (406 / 800),
                        decoration: BoxDecoration(
                          color: AppColors.lightBackground,
                          shape: BoxShape.circle,
                        ),
                        child: CustomPaint(
                          painter: NumberCirclePainter(rotation: _rotationAngle),
                        ),
                      ),
                    ),
                    Container(
                      width: screenWidth * (294 / 360),
                      height: screenHeight * (284 / 800),
                      decoration: BoxDecoration(
                        color: themeState.currentMandalaBackgroung,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      width: screenWidth * (242 / 360),
                      height: screenHeight * (242 / 800),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(themeState.currentMandalaImage),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _decreaseCount,
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
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NumberCirclePainter extends CustomPainter {
  final List<int> numbers = [3, 7, 10, 33, 100, 500, 1000];
  final double rotation;

  NumberCirclePainter({required this.rotation});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final double angleStep = 2 * pi / numbers.length;

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i < numbers.length; i++) {
      final angle = -pi / 2 + i * angleStep + rotation;
      final double offsetRadius = radius * 0.9;
      final offset = Offset(
        center.dx + offsetRadius * cos(angle),
        center.dy + offsetRadius * sin(angle),
      );

      textPainter.text = TextSpan(
        text: numbers[i].toString(),
        style: TextStyle(
          color: Colors.brown[800],
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      final position = offset - Offset(textPainter.width / 2, textPainter.height / 2);
      textPainter.paint(canvas, position);
    }
  }

  @override
  bool shouldRepaint(covariant NumberCirclePainter oldDelegate) {
    return oldDelegate.rotation != rotation;
  }
}
