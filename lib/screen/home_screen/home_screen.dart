import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seraj_app/core/utils/color_manager.dart';
import 'package:seraj_app/widget/series.dart';
import 'package:workmanager/workmanager.dart';

import '../../main.dart';
import '../../providers/theme_notifier.dart';

class HomeScreen extends ConsumerStatefulWidget {
  HomeScreen({Key? key}) : super(key: key);


  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  late double screenWidth;
  late double screenHeight;
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeNotifierProvider);
    screenWidth =MediaQuery.sizeOf(context).width;
    screenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(themeState.currentBackgroundImage,),
              fit: BoxFit.fill
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/left_floral.png"),
                   Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:const Text("سراج", style: TextStyle(fontSize: 30,color: AppColors.darkBrown),),
                  ),
                  Image.asset("assets/images/right_floral.png"),
                ],
              ),
              SizedBox(
                height: screenHeight*(90/800),
              ),
               Container(
                width: screenWidth * (309/360),
                height: screenHeight *(151/800),
                decoration: BoxDecoration(
                  color: AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                 child: Directionality(
                 textDirection: TextDirection.rtl,
                 child: Center(
                   child: Text("المستخدم عند الفجر يعرض فقط \n الأوراد و الختم الفجرية و ما بقي من اليوم يعرض الأوراد و الختم الاخرى",
                     textAlign: TextAlign.center,
                     style: TextStyle(
                       color: AppColors.darkBrown,
                       fontSize: 20,
                     ),
                   ),
                 ),
                                  ),
               ),
              // ElevatedButton(
              //   onPressed: () {
              //     flutterLocalNotificationsPlugin.show(
              //       12345,
              //       '📢 إشعار اختبار',
              //       'إذا شفت هذا الإشعار، كل شي تمام ✅',
              //       const NotificationDetails(
              //         android: AndroidNotificationDetails(
              //           'test_channel',
              //           'اختبار الإشعارات',
              //           channelDescription: 'قناة لاختبار الإشعارات العادية',
              //           importance: Importance.max,
              //           priority: Priority.high,
              //         ),
              //       ),
              //     );
              //   },
              //   child: Text('اختبار الإشعار الآن'),
              // ),
              // ElevatedButton(
              //   onPressed: () async {
              //     await Workmanager().registerOneOffTask(
              //       'test_khatma_immediate',
              //       'daily_khatma_reminder',
              //       inputData: {
              //         'khatmaId': 'test_id',
              //         'khatmaIntention': 'ختمة تجريبية',
              //       },
              //     );
              //     print('🔔 تم تسجيل مهمة اختبار فوري');
              //   },
              //   child: Text('اختبار WorkManager'),
              // ),
              SizedBox(
                height: screenHeight*(30/800),
              ),
              Series(),
            ],
          ),
        ),
      ),
    );
  }
}
