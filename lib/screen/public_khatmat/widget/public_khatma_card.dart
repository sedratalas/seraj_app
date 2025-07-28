// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:seraj_app/core/utils/color_manager.dart';
// import 'package:seraj_app/screen/public_khatmat/bloc/khatmat_event.dart';
// import 'package:seraj_app/screen/public_khatmat/bloc/khatmat_state.dart';
// import 'package:share_plus/share_plus.dart';
//
// import '../bloc/khatmat_bloc.dart';
// import '../public_khatma_parts.dart';
//
// class KhatmaCard extends StatefulWidget {
//   final String id;
//   final String intention;
//   final DateTime startDate;
//   final DateTime endDate;
//   final bool isFajr;
//   final bool isPriority;
//
//   KhatmaCard({
//     Key? key,
//     required this.id,
//     required this.intention,
//     required this.startDate,
//     required this.endDate,
//     required this.isFajr,
//     required this.isPriority,
//   }) : super(key: key);
//
//   @override
//   State<KhatmaCard> createState() => _KhatmaCardState();
// }
//
// class _KhatmaCardState extends State<KhatmaCard> {
//   late double screenWidth;
//   late double screenHeight;
//
//   @override
//   Widget build(BuildContext context) {
//     screenWidth = MediaQuery.sizeOf(context).width;
//     screenHeight = MediaQuery.sizeOf(context).height;
//
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => PublicKhatmaPartsScreen(
//               khatmaId: widget.id,
//               khatmaIntention: widget.intention,
//             ),
//           ),
//         );
//       },
//       child: Container(
//         width: screenWidth * (309 / 360),
//         height: screenHeight * (214 / 800),
//         decoration: BoxDecoration(
//           color: AppColors.lightBackground,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 // BlocListener<PublicKhatmatBloc, KhatmatState>(
//                 //   listener: (context, state) {
//                 //     if (state is KhatmaDistributionLoaded) {
//                 //       _shareKhatmaParts(context, state.distributionResult);
//                 //     } else if (state is KhatmatError && state.sourceEvent is GetKhatmaDistributionForDate) {
//                 //       if (mounted) {
//                 //         ScaffoldMessenger.of(context).showSnackBar(
//                 //           SnackBar(content: Text('حدث خطأ في جلب التوزيع: ${state.message}')),
//                 //         );
//                 //       }
//                 //     }
//                 //   },
//                 BlocListener<PublicKhatmatBloc, KhatmatState>(
//                   listener: (context, state) {
//                     print('KhatmaCard: BlocListener received state: $state'); // 🚨 أضيفي هذا السطر!
//                     if (state is KhatmaDistributionLoaded) {
//                       print('KhatmaCard: Received KhatmaDistributionLoaded. Calling _shareKhatmaParts.'); // 🚨 أضيفي هذا السطر!
//                       _shareKhatmaParts(context, state.distributionResult);
//                     } else if (state is KhatmatError && state.sourceEvent is GetKhatmaDistributionForDate) {
//                       if (mounted) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text('حدث خطأ في جلب التوزيع: ${state.message}')),
//                         );
//                       }
//                     }
//                   },
//                   child: IconButton(
//                     onPressed: () {
//                       context.read<PublicKhatmatBloc>().add(
//                         GetKhatmaDistributionForDate(khatmaId: widget.id, targetDate: DateTime.now()),
//                       );
//                     },
//                     icon: Icon(Icons.share),
//                   ),
//                 ),
//                 Text(widget.intention),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Image.asset(
//                     "assets/images/Group 22.png",
//                     width: screenWidth * (90 / 360),
//                     height: screenHeight * (79 / 800),
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Divider(
//                 color: AppColors.darkBrown,
//                 height: 1,
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 _buildDateInfo("تاريخ الانتهاء", DateFormat('d/M/yyyy').format(widget.endDate)),
//                 Image.asset(
//                   "assets/images/floral 7.png",
//                   width: screenWidth * (51 / 360),
//                   height: screenWidth * (51 / 360) * (28 / 51),
//                 ),
//                 _buildDateInfo("تاريخ البدء", DateFormat('d/M/yyyy').format(widget.startDate)),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDateInfo(String label, String value) {
//     return Column(
//       children: [
//         Text(label, style: const TextStyle(color: AppColors.darkBrown, fontSize: 14)),
//         Text(value, style: const TextStyle(color: AppColors.darkBrown, fontWeight: FontWeight.bold, fontSize: 16)),
//       ],
//     );
//   }
//
//   void _shareKhatmaParts(BuildContext context, List<Map<String, dynamic>> distributionResult) {
//     print('KhatmaCard: distributionResult received for sharing: $distributionResult');
//     if (distributionResult.isEmpty) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('لا توجد أجزاء لتتم مشاركتها لليوم الحالي!')),
//         );
//       }
//       return;
//     }
//
//     final String shareText = distributionResult.map((entry) {
//       final String name = entry['participant_name'];
//       final List<String> parts = List<String>.from(entry['assigned_parts']);
//       return 'يا $name، أجزاؤك لليوم هي: ${parts.join(', ')}';
//     }).join('\n\n');
//
//     Share.share('ختمة اليوم:\n\n$shareText').then((_) {
//       if (mounted) {
//         final currentKhatmaId = widget.id;
//         final currentTargetDate = DateTime.now();
//         print('Dispatching MarkKhatmaPartsAsRead with Khatma ID: $currentKhatmaId, Target Date: $currentTargetDate');
//         context.read<PublicKhatmatBloc>().add(
//           MarkKhatmaPartsAsRead(khatmaId: widget.id, targetDate: DateTime.now()),
//         );
//       } else {
//         print('KhatmaCard: Widget is no longer mounted, cannot dispatch MarkKhatmaPartsAsRead.');
//       }
//     }).catchError((error, stackTrace) {
//       if (mounted) {
//         print('KhatmaCard: Share failed with error: $error');
//         print('KhatmaCard: Share Stack Trace: $stackTrace');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('فشل المشاركة: $error')),
//         );
//       }
//     });
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:seraj_app/core/utils/color_manager.dart';
import 'package:seraj_app/screen/public_khatmat/bloc/khatmat_event.dart';

import '../bloc/khatmat_bloc.dart';
import '../public_khatma_parts.dart';

class KhatmaCard extends StatefulWidget {
  final String id;
  final String intention;
  final DateTime startDate;
  final DateTime endDate;
  final bool isFajr;
  final bool isPriority;

  KhatmaCard({
    Key? key,
    required this.id,
    required this.intention,
    required this.startDate,
    required this.endDate,
    required this.isFajr,
    required this.isPriority,
  }) : super(key: key);

  @override
  State<KhatmaCard> createState() => _KhatmaCardState();
}

class _KhatmaCardState extends State<KhatmaCard> {
  late double screenWidth;
  late double screenHeight;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.sizeOf(context).width;
    screenHeight = MediaQuery.sizeOf(context).height;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PublicKhatmaPartsScreen(
              khatmaId: widget.id,
              khatmaIntention: widget.intention,
            ),
          ),
        );
      },
      child: Container(
        width: screenWidth * (309 / 360),
        height: screenHeight * (214 / 800),
        decoration: BoxDecoration(
          color: AppColors.lightBackground,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    context.read<PublicKhatmatBloc>().add(
                      GetKhatmaDistributionForDate(khatmaId: widget.id, targetDate: DateTime.now()),
                    );
                  },
                  icon: const Icon(Icons.share),
                ),
                Text(widget.intention),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "assets/images/Group 22.png",
                    width: screenWidth * (90 / 360),
                    height: screenHeight * (79 / 800),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Divider(
                color: AppColors.darkBrown,
                height: 1,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDateInfo("تاريخ الانتهاء", DateFormat('d/M/yyyy').format(widget.endDate)),
                Image.asset(
                  "assets/images/floral 7.png",
                  width: screenWidth * (51 / 360),
                  height: screenWidth * (51 / 360) * (28 / 51),
                ),
                _buildDateInfo("تاريخ البدء", DateFormat('d/M/yyyy').format(widget.startDate)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateInfo(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: AppColors.darkBrown, fontSize: 14)),
        Text(value, style: const TextStyle(color: AppColors.darkBrown, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}