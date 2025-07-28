// import 'package:flutter/material.dart';
// import 'package:seraj_app/core/utils/color_manager.dart';
// import 'package:seraj_app/widget/option_circular.dart';
//
// class Series extends StatelessWidget {
//    Series({Key? key}) : super(key: key);
// late double screenWidth;
// late double screenHeight;
//
//   @override
//   Widget build(BuildContext context) {
//     screenWidth =MediaQuery.sizeOf(context).width;
//     screenHeight = MediaQuery.sizeOf(context).height;
//     return Container(
//         width: screenWidth * (348/360),
//         height: screenHeight *(122/800),
//         decoration: BoxDecoration(
//           color: AppColors.darkBrown,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//              OptionCircular(asset: "assets/images/beads.png", text: "تسبيح",),
//               OptionCircular(asset: "assets/images/quran.png", text: "سورة",),
//               OptionCircular(asset: "assets/images/series.png", text: "ختمة",),
//             ],
//           ),
//         ),
//     );
//   }
// }import 'package:flutter/material.dart';
// import 'package:seraj_app/core/utils/color_manager.dart';
// import 'package:seraj_app/widget/option_circular.dart';
//
// class Series extends StatefulWidget {
//   const Series({Key? key}) : super(key: key);
//
//   @override
//   State<Series> createState() => _SeriesState();
// }
//
// class _SeriesState extends State<Series> {
//   late double screenWidth;
//   late double screenHeight;
//
//   // تحديد الزر المفتوح حالياً
//   String? expanded; // 'tasbeeh' or 'khatma' or null
//
//   @override
//   Widget build(BuildContext context) {
//     screenWidth = MediaQuery.sizeOf(context).width;
//     screenHeight = MediaQuery.sizeOf(context).height;
//
//     return Column(
//       children: [
//         Container(
//           width: screenWidth * (348 / 360),
//           decoration: BoxDecoration(
//             color: AppColors.darkBrown,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 // زر تسبيح
//                 GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       expanded = expanded == 'tasbeeh' ? null : 'tasbeeh';
//                     });
//                   },
//                   child: OptionCircular(
//                     asset: "assets/images/beads.png",
//                     text: "تسبيح",
//                   ),
//                 ),
//                 // زر سورة
//                 OptionCircular(
//                   asset: "assets/images/quran.png",
//                   text: "سورة",
//                 ),
//                 // زر ختمة
//                 GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       expanded = expanded == 'khatma' ? null : 'khatma';
//                     });
//                   },
//                   child: OptionCircular(
//                     asset: "assets/images/series.png",
//                     text: "ختمة",
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//
//         // المساحة الإضافية (Animated)
//         AnimatedSize(
//           duration: Duration(milliseconds: 300),
//           curve: Curves.easeInOut,
//           child: SizedBox(
//             height: (expanded == null) ? 0 : screenHeight * 0.15,
//             child: (expanded == null)
//                 ? null
//                 : Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       if (expanded == 'tasbeeh') ...[
//                         OptionCircular(
//                           asset: "assets/images/zikr_session.png",
//                           text: "جلسة ذكر",
//                         ),
//                         OptionCircular(
//                           asset: "assets/images/zikr_quiz.png",
//                           text: "مسابقة بذكر",
//                         ),
//                       ] else if (expanded == 'khatma') ...[
//                         OptionCircular(
//                           asset: "assets/images/khatma_personal.png",
//                           text: "ختمة خاصة",
//                         ),
//                         OptionCircular(
//                           asset: "assets/images/khatma_public.png",
//                           text: "ختمة عامة",
//                         ),
//                       ],
//                     ],
//                   ),
//           ),
//         ),
//       ],
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:seraj_app/core/utils/color_manager.dart';
// import 'package:seraj_app/widget/option_circular.dart';
//
// class Series extends StatefulWidget {
//   const Series({Key? key}) : super(key: key);
//
//   @override
//   State<Series> createState() => _SeriesState();
// }
//
// class _SeriesState extends State<Series> {
//   late double screenWidth;
//   late double screenHeight;
//
//   // تحديد الزر المفتوح حالياً
//   String? expanded; // 'tasbeeh' or 'khatma' or null
//
//   @override
//   Widget build(BuildContext context) {
//     screenWidth = MediaQuery.sizeOf(context).width;
//     screenHeight = MediaQuery.sizeOf(context).height;
//
//     return Column(
//       children: [
//         Container(
//           width: screenWidth * (348 / 360),
//           decoration: BoxDecoration(
//             color: AppColors.darkBrown,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 // زر تسبيح
//                 GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       expanded = expanded == 'tasbeeh' ? null : 'tasbeeh';
//                     });
//                   },
//                   child: OptionCircular(
//                     asset: "assets/images/beads.png",
//                     text: "تسبيح",
//                   ),
//                 ),
//                 // زر سورة
//                 OptionCircular(
//                   asset: "assets/images/quran.png",
//                   text: "سورة",
//                 ),
//                 // زر ختمة
//                 GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       expanded = expanded == 'khatma' ? null : 'khatma';
//                     });
//                   },
//                   child: OptionCircular(
//                     asset: "assets/images/series.png",
//                     text: "ختمة",
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         AnimatedSize(
//           duration: Duration(milliseconds: 300),
//           curve: Curves.easeInOut,
//           child: SizedBox(
//             height: (expanded == null) ? 0 : screenHeight * 0.15,
//             child: (expanded == null)
//                 ? null
//                 : Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 if (expanded == 'tasbeeh') ...[
//                   OptionCircular(
//                     asset: "assets/images/meeting 1.png",
//                     text: "جلسة ذكر",
//                   ),
//                   OptionCircular(
//                     asset: "assets/images/Group 35.png",
//                     text: "مسابقة بذكر",
//                   ),
//                 ] else if (expanded == 'khatma') ...[
//                   OptionCircular(
//                     asset: "assets/images/Group 45.png",
//                     text: "ختمة خاصة",
//                   ),
//                   OptionCircular(
//                     asset: "assets/images/Group 41.png",
//                     text: "ختمة عامة",
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:seraj_app/core/utils/color_manager.dart';
import 'package:seraj_app/screen/private_khatmat/private_khatmat_screen.dart';
import 'package:seraj_app/screen/public_khatmat/public_khatmat_screen.dart';
import 'package:seraj_app/screen/tasbeeh_counter.dart';
import 'package:seraj_app/screen/zekir_session/azkar_sessions.dart';
import 'package:seraj_app/widget/option_circular.dart';

class Series extends StatefulWidget {
  const Series({Key? key}) : super(key: key);

  @override
  State<Series> createState() => _SeriesState();
}

class _SeriesState extends State<Series> {
  late double screenWidth;
  late double screenHeight;

  String? expanded;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.sizeOf(context).width;
    screenHeight = MediaQuery.sizeOf(context).height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        Container(
          width: screenWidth * (348 / 360),
          decoration: BoxDecoration(
            color: AppColors.darkBrown,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              GestureDetector(
                onTap: () {
                  setState(() {
                    expanded = expanded == 'tasbeeh' ? null : 'tasbeeh';
                  });
                },
                child: OptionCircular(
                  asset: "assets/images/beads.png",
                  text: "تسبيح",
                ),
              ),


              OptionCircular(
                asset: "assets/images/quran.png",
                text: "سورة",
              ),


              GestureDetector(
                onTap: () {
                  setState(() {
                    expanded = expanded == 'khatma' ? null : 'khatma';
                  });
                },
                child: OptionCircular(
                  asset: "assets/images/series.png",
                  text: "ختمة",
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: AnimatedSize(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: expanded == 'tasbeeh'
                    ? Column(
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AzkarSessions(),
                            ),
                        );
                      },
                      child: OptionCircular(
                        asset: "assets/images/meeting 1.png",
                        text: "جلسة ذكر",
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TasbeehCounter(),
                          ),
                        );
                      },
                      child: OptionCircular(
                        asset: "assets/images/Group 35.png",
                        text: "مسابقة بذكر",
                      ),
                    ),
                  ],
                )
                    : SizedBox.shrink(),
              ),
            ),

            Expanded(child: SizedBox()),
            Expanded(
              child: AnimatedSize(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: expanded == 'khatma'
                    ? Column(
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => KhatmatScreen(),
                          ),
                        );
                      },
                      child: OptionCircular(
                        asset: "assets/images/Group 45.png",
                        text: "ختمة خاصة",
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PublicKhatmatScreen(),
                          ),
                        );
                      },
                      child: OptionCircular(
                        asset: "assets/images/Group 41.png",
                        text: "ختمة عامة",
                      ),
                    ),
                  ],
                )
                    : SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}



