// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:share_plus/share_plus.dart';
// import '../../../core/utils/color_manager.dart';
// import '../../../main.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:uuid/uuid.dart';
// import '../../../model/public_khatma_model.dart';
// import '../bloc/khatmat_bloc.dart';
// import '../bloc/khatmat_event.dart';
// import '../bloc/khatmat_state.dart';
//
// class AddPublicParticipantsScreen extends StatefulWidget {
//   final KhatmaModel khatma;
//
//   const AddPublicParticipantsScreen({Key? key, required this.khatma}) : super(key: key);
//
//   @override
//   State<AddPublicParticipantsScreen> createState() => _AddPublicParticipantsScreenState();
// }
//
// class _AddPublicParticipantsScreenState extends State<AddPublicParticipantsScreen> {
//   final TextEditingController _participantNamesController = TextEditingController();
//   late double screenWidth;
//   late double screenHeight;
//
//   @override
//   void dispose() {
//     _participantNamesController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     screenWidth = MediaQuery.sizeOf(context).width;
//     screenHeight = MediaQuery.sizeOf(context).height;
//
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: BlocListener<PublicKhatmatBloc, KhatmatState>(
//         listener: (context, state) {
//           if (state is KhatmaAdded) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('تمت إضافة الختمة وتوزيع الأجزاء!')),
//                 );
//
//             if (state.distributionResult != null && state.distributionResult!.isNotEmpty) {
//               _shareKhatmaParts(state.distributionResult!);
//               print('Distribution Result: ${state.distributionResult}');
//             }
//             Future.delayed(const Duration(milliseconds: 300), () {
//               if (mounted && Navigator.of(context).canPop()) {
//                 Navigator.pop(context, true);
//               }
//             });
//             _scheduleDailyReminderNotification(
//               khatmaId: state.createdKhatma.id,
//               khatmaIntention: state.createdKhatma.intention,
//               startDate: state.createdKhatma.startDate,
//               durationDays: state.createdKhatma.durationDay,
//               creationTime: state.createdKhatma.createdAt,
//           );
//           } else if (state is KhatmatError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('حدث خطأ: ${state.message}')),
//             );
//           }
//         },
//         child: Center(
//           child: Container(
//             margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
//             padding: const EdgeInsets.all(25.0),
//             decoration: BoxDecoration(
//               color: AppColors.darkBrown,
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Expanded(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Align(
//                     alignment: Alignment.topLeft,
//                     child: IconButton(
//                       icon: Icon(Icons.close, color: Colors.white),
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                     ),
//                   ),
//                   Text(
//                     "أسماء المشاركين (افصل بفاصلة ,)",
//                     style: TextStyle(color: Colors.white),
//                     textAlign: TextAlign.right,
//                   ),
//                   const SizedBox(height: 8),
//                   TextField(
//                     controller: _participantNamesController,
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: Colors.white,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                         borderSide: BorderSide.none,
//                       ),
//                       hintText: 'مثال: أحمد, فاطمة, علي',
//                       hintStyle: TextStyle(color: Colors.grey[400]),
//                     ),
//                     maxLines: 3,
//                     keyboardType: TextInputType.text,
//                     textAlign: TextAlign.right,
//                   ),
//                   const SizedBox(height: 30),
//                   GestureDetector(
//                     onTap: _addKhatmaAndShare,
//                     child: Container(
//                       height: screenHeight * (41 / 800),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         color: AppColors.lightBackground,
//                       ),
//                       child: Center(
//                         child: Text(
//                           "إضافة ومشاركة",
//                           style: TextStyle(
//                             color: AppColors.darkBrown,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 18,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _addKhatmaAndShare() {
//     final String namesText = _participantNamesController.text.trim();
//     if (namesText.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('الرجاء إدخال أسماء المشاركين!')),
//       );
//       return;
//     }
//
//     final List<String> participantNames = namesText
//         .split('،').map((name) => name.trim()).where((name) => name.isNotEmpty).toList();
//
//     if (participantNames.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('الرجاء إدخال أسماء مشاركين صحيحة!')),
//       );
//       return;
//     }
//
//     context.read<PublicKhatmatBloc>().add(
//       AddKhatma(
//         khatma: widget.khatma,
//         participantNames: participantNames,
//       ),
//     );
//   }
//
//   void _shareKhatmaParts(List<Map<String, dynamic>> distributionResult) {
//     if (distributionResult.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('لا توجد أجزاء لتتم مشاركتها!')),
//       );
//       return;
//     }
//
//     final String shareText = distributionResult.map((entry) {
//       final String name = entry['participant_name'];
//       final List<String> parts = List<String>.from(entry['assigned_parts']);
//       return 'يا $name، أجزاؤك لليوم هي: ${parts.join(', ')}';
//     }).join('\n\n');
//
//     Share.share('ختمة اليوم:\n\n$shareText');
//   }
//   Future<void> _scheduleDailyReminderNotification({
//     required String khatmaId,
//     required String khatmaIntention,
//     required DateTime startDate,
//     required num durationDays,
//     required DateTime creationTime,
//   }) async {
//     if (await Permission.scheduleExactAlarm.isDenied) {
//       final status = await Permission.scheduleExactAlarm.request();
//       if (status.isDenied || status.isPermanentlyDenied) {
//         // إذا رفض المستخدم الإذن، لا يمكننا جدولة التنبيه الدقيق
//         // يمكنكِ إظهار رسالة للمستخدم هنا
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('الرجاء منح إذن التنبيهات الدقيقة لجدولة الختمة بدقة.')),
//         );
//         debugPrint('Exact alarm permission denied.');
//         return; // توقفي هنا إذا لم يتم منح الإذن
//       }
//     }
//     final int hour = creationTime.hour;
//     final int minute = creationTime.minute;
//     final int notificationId = khatmaId.hashCode;
//
//     // إلغاء أي إشعارات سابقة بنفس الـ ID لهذه الختمة (إذا كانت مجدولة)
//     await flutterLocalNotificationsPlugin.cancel(notificationId);
//
//
//     // جدولة الإشعار الأول لليوم التالي
//     // نبدأ من تاريخ إنشاء الختمة + 1 يوم (أو تاريخ البداية +1 إذا كانت الختمة ستبدأ لاحقاً)
//     // وسنجدوله في نفس الساعة والدقيقة التي تم فيها إنشاء الختمة.
//
//    // DateTime nextScheduledDate = creationTime.add(const Duration(seconds: 40));
//     tz.TZDateTime scheduledDate = tz.TZDateTime.now(tz.local).add(const Duration(minutes: 1));
//     // للتأكد أن الإشعار لا يقل عن 12 ساعة من الآن لتجنب مشاكل الجدولة الفورية،
//     // ويمكن تعديل هذا المنطق.
//     // الأفضل أن يتم جدولة الإشعار الأول فقط لليوم التالي
//     // ثم تجديله للتكرار اليومي.
//
//     // نضبط التاريخ ليكون أول يوم بعد تاريخ انتهاء الختمة (هذا هو اليوم الذي نريد فيه الإشعار)
//     // ونتأكد أنه ليس قبل الآن
//     /*tz.TZDateTime scheduledDate = tz.TZDateTime(
//       tz.local,
//       nextScheduledDate.year,
//       nextScheduledDate.month,
//       nextScheduledDate.day,
//       hour,
//       minute,
//     );*/
//
//     // تأكد أن موعد الإشعار في المستقبل
//     if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
//       // إذا كان الوقت قد فات اليوم، نجدوله لليوم التالي
//       scheduledDate = scheduledDate.add(const Duration(days: 1));
//     }
// try{
//   await flutterLocalNotificationsPlugin.zonedSchedule(
//     notificationId,
//     'تذكير ختمة القرآن',
//     'حان وقت توزيع أجزاء ختمة "$khatmaIntention" لليوم الجديد.',
//     scheduledDate,
//     const NotificationDetails(
//       android: AndroidNotificationDetails(
//         'khatma_reminder_channel', // معرف قناة جديد (فريد عن السابق)
//         'تذكيرات توزيع الأجزاء', // اسم القناة
//         channelDescription: 'قناة إشعارات لتذكيرك بتوزيع أجزاء الختمات اليومية.',
//         importance: Importance.max,
//         priority: Priority.high,
//         showWhen: false,
//       ),
//       iOS: DarwinNotificationDetails(),
//     ),
//     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//     // uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
//     // هذا هو الأهم: ليتكرر يومياً في نفس الوقت
//     matchDateTimeComponents: DateTimeComponents.time,
//     payload: khatmaId, // يمكننا تمرير ID الختمة كـ payload
//
//   );
//   print('DEBUG: Notification successfully scheduled.');
//   debugPrint('Scheduled daily reminder for Khatma ID: $khatmaId at ${scheduledDate.hour}:${scheduledDate.minute} daily.');
// }catch(e){
//   print('DEBUG: Error scheduling notification: $e');
// }
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:workmanager/workmanager.dart';
import '../../../core/utils/color_manager.dart';
import '../../../model/public_khatma_model.dart';
import '../bloc/khatmat_bloc.dart';
import '../bloc/khatmat_event.dart';
import '../bloc/khatmat_state.dart';

class AddPublicParticipantsScreen extends StatefulWidget {
  final KhatmaModel khatma;

  const AddPublicParticipantsScreen({Key? key, required this.khatma}) : super(key: key);

  @override
  State<AddPublicParticipantsScreen> createState() => _AddPublicParticipantsScreenState();
}

class _AddPublicParticipantsScreenState extends State<AddPublicParticipantsScreen> {
  final TextEditingController _participantNamesController = TextEditingController();
  late double screenWidth;
  late double screenHeight;

  @override
  void dispose() {
    _participantNamesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.sizeOf(context).width;
    screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocListener<PublicKhatmatBloc, KhatmatState>(
        listener: (context, state) {
          if (state is KhatmaAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تمت إضافة الختمة وتوزيع الأجزاء!')),
            );

            if (state.distributionResult != null && state.distributionResult!.isNotEmpty) {
              _shareKhatmaParts(state.distributionResult!);
              print('Distribution Result: ${state.distributionResult}');
            }

            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted && Navigator.of(context).canPop()) {
                Navigator.pop(context, true);
              }
            });

            _scheduleDailyReminderNotification(
              khatmaId: state.createdKhatma.id,
              khatmaIntention: state.createdKhatma.intention,
              creationTime: state.createdKhatma.createdAt,
            );
          } else if (state is KhatmatError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('حدث خطأ: ${state.message}')),
            );
          }
        },
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            padding: const EdgeInsets.all(25.0),
            decoration: BoxDecoration(
              color: AppColors.darkBrown,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Text(
                  "أسماء المشاركين (افصل بفاصلة ،)",
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _participantNamesController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'مثال: سدرة،نور،ريم',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                  maxLines: 3,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: _addKhatmaAndShare,
                  child: Container(
                    height: screenHeight * (41 / 800),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.lightBackground,
                    ),
                    child: Center(
                      child: Text(
                        "إضافة ومشاركة",
                        style: TextStyle(
                          color: AppColors.darkBrown,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addKhatmaAndShare() {
    final String namesText = _participantNamesController.text.trim();
    if (namesText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال أسماء المشاركين!')),
      );
      return;
    }

    final List<String> participantNames = namesText
        .split('،').map((name) => name.trim()).where((name) => name.isNotEmpty).toList();

    if (participantNames.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال أسماء مشاركين صحيحة!')),
      );
      return;
    }

    context.read<PublicKhatmatBloc>().add(
      AddKhatma(
        khatma: widget.khatma,
        participantNames: participantNames,
      ),
    );
  }

  void _shareKhatmaParts(List<Map<String, dynamic>> distributionResult) {
    if (distributionResult.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا توجد أجزاء لتتم مشاركتها!')),
      );
      return;
    }

    final String shareText = distributionResult.map((entry) {
      final String name = entry['participant_name'];
      final List<String> parts = List<String>.from(entry['assigned_parts']);
      return 'يا $name، أجزاؤك لليوم هي: ${parts.join(', ')}';
    }).join('\n\n');

    Share.share('ختمة اليوم:\n\n$shareText');
  }

  Future<void> _scheduleDailyReminderNotification({
    required String khatmaId,
    required String khatmaIntention,
    required DateTime creationTime,
  }) async {
    if (await Permission.scheduleExactAlarm.isDenied) {
      final status = await Permission.scheduleExactAlarm.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('الرجاء منح إذن التنبيهات الدقيقة لجدولة الختمة بدقة.')),
        );
        return;
      }
    }

    final DateTime now = DateTime.now();
    final DateTime firstSchedule = DateTime(
      now.year,
      now.month,
      now.day,
      creationTime.hour,
      creationTime.minute,
    ).add(const Duration(minutes: 15));

    final Duration initialDelay = firstSchedule.difference(now);

    await Workmanager().registerPeriodicTask(
      'khatma_$khatmaId',
      'daily_khatma_reminder',
      initialDelay: initialDelay,
      frequency: const Duration(minutes: 15),
      inputData: {
        'khatmaId': khatmaId,
        'khatmaIntention': khatmaIntention,
      },
      constraints: Constraints(
        networkType: NetworkType.not_required,
        requiresCharging: false,
        requiresBatteryNotLow: false,
      ),
    );
    // await Workmanager().registerOneOffTask(
//   'test_khatma_immediate',
//   'daily_khatma_reminder',
//   inputData: {
//     'khatmaId': 'test_id',
//     'khatmaIntention': 'ختمة تجريبية',
//   },
// );

  }
}