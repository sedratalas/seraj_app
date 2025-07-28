// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:seraj_app/core/utils/color_manager.dart';
// import 'package:seraj_app/screen/public_khatmat/bloc/khatmat_bloc.dart';
// import 'package:seraj_app/screen/public_khatmat/bloc/khatmat_event.dart';
// import 'package:seraj_app/screen/public_khatmat/bloc/khatmat_state.dart';
// import 'package:seraj_app/screen/public_khatmat/widget/add_public_khatma.dart';
// import 'package:seraj_app/screen/public_khatmat/widget/public_khatma_card.dart';
// import 'package:seraj_app/screen/zekir_session/widget/zekir_card.dart';
//
// import '../../providers/theme_notifier.dart';
//
//
//
// class PublicKhatmatScreen extends ConsumerStatefulWidget {
//   const PublicKhatmatScreen({Key? key}) : super(key: key);
//
//   @override
//
//   ConsumerState<PublicKhatmatScreen> createState() => _PublicKhatmatScreenState();
//
// }
//
// class _PublicKhatmatScreenState extends ConsumerState<PublicKhatmatScreen> {
//   void initState() {
//     super.initState();
//     context.read<PublicKhatmatBloc>().add(LoadKhatmat());
//   }
//   @override
//   late double screenWidth;
//   Widget build(BuildContext context) {
//     screenWidth = MediaQuery.sizeOf(context).width;
//     final themeState = ref.watch(themeNotifierProvider);
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(image: AssetImage(themeState.currentBackgroundImage,),
//               fit: BoxFit.fill
//           ),
//         ),
//
//         child: BlocBuilder<PublicKhatmatBloc, KhatmatState>(
//           builder: (context, state) {
//             if (state is LoadingKhatmat) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (state is KhatmatError) {
//               return Center(child: Text('Error: ${state.message}'));
//             } else if (state is LoadedKhatmat) {
//               if (state.khatmat.isEmpty) {
//                 return const Center(child: Text('لا توجد ختمات حتى الآن.'));
//               }
//               return SafeArea(
//                 child: Column(
//                   children: [
//                     Padding(
//                       padding:  EdgeInsets.only(left: screenWidth*(20/300),right:screenWidth*(20/300) ),
//                       child: Row(
//                         children: [
//                           GestureDetector(
//                               onTap: (){
//                                 Navigator.pop(context);
//                               },
//                               child: Image.asset("assets/images/leftarrow.png")),
//                           Expanded(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Image.asset("assets/images/left_floral.png"),
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text("الختمات العامة"),
//                                 ),
//                                 Image.asset("assets/images/right_floral.png"),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Expanded(
//                       child: ListView.builder(
//                         itemCount: state.khatmat.length,
//                         itemBuilder: (context, index) {
//                           final khatma = state.khatmat[index];
//                           return Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25),
//                             child: KhatmaCard(
//                               id: khatma.id!,
//                               intention: khatma.intention,
//                               startDate: khatma.startDate,
//                               endDate: khatma.endDate,
//                               isFajr:khatma.isFajr,
//                               isPriority: khatma.isPriority,
//
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }
//             return const Center(child: Text('جاري التحميل أو لا توجد بيانات.'));
//           },
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: AppColors.darkBrown,
//         onPressed: (){
//           _showIntentionBottomSheet(context);
//         },
//         child: Icon(Icons.add, color: Colors.white,),
//       ),
//     );
//   }
//   void _showIntentionBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (BuildContext context) {
//         return Padding(
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//           ),
//           child: const AddPublicKhatmaScreen(),
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seraj_app/core/utils/color_manager.dart';
import 'package:seraj_app/screen/public_khatmat/bloc/khatmat_bloc.dart';
import 'package:seraj_app/screen/public_khatmat/bloc/khatmat_event.dart';
import 'package:seraj_app/screen/public_khatmat/bloc/khatmat_state.dart';
import 'package:seraj_app/screen/public_khatmat/widget/add_public_khatma.dart';
import 'package:seraj_app/screen/public_khatmat/widget/public_khatma_card.dart';
import 'package:share_plus/share_plus.dart';

import '../../providers/theme_notifier.dart';

class PublicKhatmatScreen extends ConsumerStatefulWidget {
  const PublicKhatmatScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PublicKhatmatScreen> createState() => _PublicKhatmatScreenState();
}

class _PublicKhatmatScreenState extends ConsumerState<PublicKhatmatScreen> {
  late double screenWidth;

  @override
  void initState() {
    super.initState();
    context.read<PublicKhatmatBloc>().add(LoadKhatmat());
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.sizeOf(context).width;
    final themeState = ref.watch(themeNotifierProvider);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(themeState.currentBackgroundImage),
            fit: BoxFit.fill,
          ),
        ),
        child: BlocListener<PublicKhatmatBloc, KhatmatState>(
          listener: (context, state) {
            if (state is KhatmaDistributionLoaded) {
              print('PublicKhatmatScreen: Received KhatmaDistributionLoaded state.');
              print('PublicKhatmatScreen: Distribution Result: ${state.distributionResult}');
              print('PublicKhatmatScreen: Khatma ID: ${state.khatmaId}, Target Date: ${state.targetDate}');
              _shareKhatmaPartsFromScreen(context, state.distributionResult, state.khatmaId, state.targetDate);
            } else if (state is KhatmatError && state.sourceEvent is GetKhatmaDistributionForDate) {
              print('PublicKhatmatScreen: Error getting distribution: ${state.message}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('حدث خطأ في جلب التوزيع: ${state.message}')),
              );
            }
          },
          child: BlocBuilder<PublicKhatmatBloc, KhatmatState>(
            builder: (context, state) {
              if (state is LoadingKhatmat) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is KhatmatError) {
                return Center(child: Text('Error: ${state.message}'));
              } else if (state is LoadedKhatmat) {
                if (state.khatmat.isEmpty) {
                  return const Center(child: Text('لا توجد ختمات حتى الآن.'));
                }
                return SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: screenWidth * (20 / 300), right: screenWidth * (20 / 300)),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Image.asset("assets/images/leftarrow.png"),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset("assets/images/left_floral.png"),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("الختمات العامة"),
                                  ),
                                  Image.asset("assets/images/right_floral.png"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.khatmat.length,
                          itemBuilder: (context, index) {
                            final khatma = state.khatmat[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25),
                              child: KhatmaCard(
                                id: khatma.id!,
                                intention: khatma.intention,
                                startDate: khatma.startDate,
                                endDate: khatma.endDate,
                                isFajr: khatma.isFajr,
                                isPriority: khatma.isPriority,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const Center(child: Text('جاري التحميل أو لا توجد بيانات.'));
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.darkBrown,
        onPressed: () {
          _showIntentionBottomSheet(context);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showIntentionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: const AddPublicKhatmaScreen(),
        );
      },
    );
  }

  void _shareKhatmaPartsFromScreen(BuildContext context, List<Map<String, dynamic>> distributionResult, String khatmaId, DateTime targetDate) {
    print('PublicKhatmatScreen: _shareKhatmaPartsFromScreen called.');

    if (distributionResult.isEmpty) {
      print('PublicKhatmatScreen: distributionResult is empty.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا توجد أجزاء لتتم مشاركتها لليوم الحالي!')),
      );
      return;
    }

    print('PublicKhatmatScreen: Building share text.');
    final String shareText = distributionResult.map((entry) {
      final String name = entry['participant_name'];
      final List<String> parts = List<String>.from(entry['assigned_parts']);
      return 'يا $name، أجزاؤك لليوم هي: ${parts.join(', ')}';
    }).join('\n\n');

    print('PublicKhatmatScreen: Share text generated: \n$shareText');
    Share.share('ختمة اليوم:\n\n$shareText').then((_) {
      print('PublicKhatmatScreen: Share completed/dismissed.');
      if (mounted) {
        context.read<PublicKhatmatBloc>().add(
          MarkKhatmaPartsAsRead(khatmaId: khatmaId, targetDate: targetDate),
        );
      }
    }).catchError((error, stackTrace) {
      print('PublicKhatmatScreen: Share failed with error: $error\n$stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل المشاركة: $error')),
        );
      }
    });
  }
}