// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:seraj_app/core/utils/color_manager.dart';
// import 'package:seraj_app/screen/private_khatmat/bloc/khatmat_event.dart';
// import 'package:seraj_app/screen/zekir_session/widget/zekir_card.dart';
//
// import '../private_khatmat/bloc/khatmat_bloc.dart';
//
//
// class KhatmatScreen extends StatefulWidget {
//   const KhatmatScreen({Key? key}) : super(key: key);
//
//   @override
//
//   State<KhatmatScreen> createState() => _KhatmatScreenState();
//
// }
//
// class _KhatmatScreenState extends State<KhatmatScreen> {
//   void initState() {
//     super.initState();
//     context.read<KhatmatBloc>().add(LoadKhatmat());
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(image: AssetImage("assets/images/splash (1).png",),
//               fit: BoxFit.fill
//           ),
//         ),
//
//         child: BlocBuilder<KhatmatBloc, KhatmatState>(
//           builder: (context, state) {
//             if (state is LoadingKhatmat) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (state is KhatmatError) {
//               return Center(child: Text('Error: ${state.message}'));
//             } else if (state is LoadedKhatmat) {
//               if (state.khatmat.isEmpty) {
//                 return const Center(child: Text('لا توجد ختمات حتى الآن.'));
//               }
//               return ListView.builder(
//                 itemCount: state.khatmat.length,
//                 itemBuilder: (context, index) {
//                   final khatma = state.khatmat[index];
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25),
//                     child: KhatmaCard(
//                       id: khatma.id!,
//                       intention: khatma.intention,
//                       startDate: khatma.startDate,
//                       endDate: khatma.endDate,
//                       isFajr:khatma.isFajr,
//                       isPriority: khatma.isPriority,
//
//                     ),
//                   );
//                 },
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
//           child: const AddPrivateKhatmaScreen(),
//         );
//       },
//     );
//   }
// }
