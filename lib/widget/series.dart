import 'package:flutter/material.dart';
import 'package:seraj_app/core/utils/color_manager.dart';
import 'package:seraj_app/widget/option_circular.dart';

class Series extends StatelessWidget {
   Series({Key? key}) : super(key: key);
late double screenWidth;
late double screenHeight;

  @override
  Widget build(BuildContext context) {
    screenWidth =MediaQuery.sizeOf(context).width;
    screenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: Container(
        width: screenWidth * (348/360),
        height: screenHeight *(122/800),
        decoration: BoxDecoration(
          color: AppColors.darkBrown,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           OptionCircular(asset: "assets/images/beads.png", text: "تسبيح",),
            OptionCircular(asset: "assets/images/quran.png", text: "تسبيح",),
            OptionCircular(asset: "assets/images/series.png", text: "تسبيح",),
          ],
        ),
      ),
    );
  }
}
