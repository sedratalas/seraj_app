import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:workmanager/workmanager.dart';
import '../../../core/utils/color_manager.dart';
import '../../../model/zekir_session_model.dart';
import '../bloc/zekir_session_bloc.dart';
import '../bloc/zekir_session_event.dart';
import '../bloc/zekir_session_state.dart';

class AddZekirParticipantScreen extends StatefulWidget {
  final ZekirSession zekirSession;

  const AddZekirParticipantScreen({Key? key, required this.zekirSession}) : super(key: key);

  @override
  State<AddZekirParticipantScreen> createState() => _AddZekirParticipantScreenState();
}

class _AddZekirParticipantScreenState extends State<AddZekirParticipantScreen> {
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
      body: BlocListener<ZekirSessionBloc, ZekirSessionState>(
        listener: (context, state) {
          if (state is ZekirSessionAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تمت إضافة جلسة الذكر وتوزيع الأذكار!')),
            );

            if (state.distributionResult != null && state.distributionResult!.isNotEmpty) {
              _shareZekirParts(state.distributionResult!, state.createdSession.dhikrType);
            }

            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted && Navigator.of(context).canPop()) {
                Navigator.pop(context, true);
              }
            });

            // if (state.createdSession.createdAt != null) {
            //   _scheduleDailyReminderNotification(
            //     zekirId: state.createdSession.id!,
            //     zekirIntention: state.createdSession.dhikrType,
            //     creationTime: state.createdSession.createdAt!,
            //   );
            // } else {
            //
            //   print('Warning: createdSession.createdAt is null. Cannot schedule reminder.');
            // }
          } else if (state is ZekirSessionError) {
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
                  onTap: _addZekirSessionAndShare,
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

  void _addZekirSessionAndShare() {
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

    context.read<ZekirSessionBloc>().add(
      AddZekirSessionWithParticipants(
        session: widget.zekirSession,
        participantNames: participantNames,
      ),
    );
  }

  void _shareZekirParts(List<Map<String, dynamic>> distributionResult, String dhikrType) {
    if (distributionResult.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا توجد أذكار لتتم مشاركتها!')),
      );
      return;
    }

    final String shareText = distributionResult.map((entry) {
      final String name = entry['participant_name'];
      final int assignedCount = entry['assigned_count'];
      return 'يا $name، العدد اليومي المفروض من $dhikrType هو: $assignedCount';
    }).join('\n\n');

    Share.share('توزيع أذكار اليوم:\n\n$shareText');
  }

  // Future<void> _scheduleDailyReminderNotification({
  //   required String zekirId,
  //   required String zekirIntention,
  //   required DateTime creationTime,
  // }) async {
  //   if (await Permission.scheduleExactAlarm.isDenied) {
  //     final status = await Permission.scheduleExactAlarm.request();
  //     if (status.isDenied || status.isPermanentlyDenied) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('الرجاء منح إذن التنبيهات الدقيقة لجدولة الذكر بدقة.')),
  //       );
  //       return;
  //     }
  //   }
  //
  //   final DateTime now = DateTime.now();
  //   final DateTime firstSchedule = DateTime(
  //     now.year,
  //     now.month,
  //     now.day,
  //     creationTime.hour,
  //     creationTime.minute,
  //   ).add(const Duration(minutes: 15));
  //
  //   final Duration initialDelay = firstSchedule.difference(now);
  //
  //   await Workmanager().registerPeriodicTask(
  //     'zekir_$zekirId',
  //     'daily_zekir_reminder',
  //     initialDelay: initialDelay,
  //     frequency: const Duration(minutes: 15),
  //     inputData: {
  //       'zekirId': zekirId,
  //       'zekirIntention': zekirIntention,
  //     },
  //     constraints: Constraints(
  //       networkType: NetworkType.not_required,
  //       requiresCharging: false,
  //       requiresBatteryNotLow: false,
  //     ),
  //  );
  //}
}