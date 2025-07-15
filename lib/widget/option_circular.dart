import 'package:flutter/material.dart';
import 'package:seraj_app/core/utils/color_manager.dart';

class OptionCircular extends StatelessWidget {
  OptionCircular({
    required this.asset,
    required this.text,
  });
   String asset;
 String text;
  @override
  Widget build(BuildContext context) {
    return
       CircleAvatar(
        backgroundColor: AppColors.duskPeach,
        radius: 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(asset),
            Text(text),
          ],
        ),
    );
  }


}
