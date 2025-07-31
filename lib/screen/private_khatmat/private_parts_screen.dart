import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seraj_app/core/utils/color_manager.dart';
import '../../providers/theme_notifier.dart';
import 'bloc/khatmat_bloc.dart';
import 'bloc/khatmat_event.dart';
import 'bloc/khatmat_state.dart';
import 'package:seraj_app/model/privat_parts_model.dart';

class PrivateKhatmaPartsScreen extends ConsumerStatefulWidget {
  final String khatmaId;
  final String khatmaIntention;
  final String khatmaIndex;

  const PrivateKhatmaPartsScreen({Key? key, required this.khatmaId, required this.khatmaIntention, required this.khatmaIndex}) : super(key: key);

  @override
  ConsumerState<PrivateKhatmaPartsScreen> createState() => _PrivateKhatmaPartsScreenState();
}

class _PrivateKhatmaPartsScreenState extends ConsumerState<PrivateKhatmaPartsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<KhatmatBloc>().add(LoadKhatmaParts(khatmaId: widget.khatmaId));
  }
  late double screenWidth;
  late double screenHeight;
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.sizeOf(context).width;
    screenHeight = MediaQuery.sizeOf(context).height;
    final themeState = ref.watch(themeNotifierProvider);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, dynamic? result) {
        if (!didPop) {
          return;
        }
        context.read<KhatmatBloc>().add(LoadKhatmat());
      },
      child: Scaffold(
        body: BlocBuilder<KhatmatBloc, KhatmatState>(
          builder: (context, state) {
            if (state is LoadingKhatmaParts) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LoadedKhatmaParts || state is UpdatingKhatmaPartStatus) {
              final List<KhatmaPartModel> khatmaParts = state is LoadedKhatmaParts
                  ? state.khatmaParts
                  : (state as UpdatingKhatmaPartStatus).khatmaParts;

              if (khatmaParts.isEmpty) {
                return const Center(child: Text('لا توجد أجزاء لهذه الختمة بعد.'));
              }
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage(themeState.currentBackgroundImage),
                      fit: BoxFit.fill
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding:  EdgeInsets.only(left: screenWidth*(20/300),right:screenWidth*(20/300) ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                                onTap: (){
                                  Navigator.pop(context);
                                  context.read<KhatmatBloc>().add(LoadKhatmat());
                                },
                                child: Image.asset("assets/images/leftarrow.png")),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(themeState.currentLeftFloralImage),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("${widget.khatmaIndex}   ختمة " ,style: TextStyle(fontSize: 30,color: themeState.sirajTextColor, fontFamily: "H-ALHFHAF",),),
                                  ),
                                  Image.asset(themeState.currentRightFloralImage),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Container(
                          width: screenWidth * (311 / 360),
                          height: screenHeight * (63 / 800),
                          decoration: BoxDecoration(
                            color: Color(0xffFEFAE0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Text(
                                    widget.khatmaIntention,
                                    style: const TextStyle(
                                      color: AppColors.darkBrown,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.right,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  "assets/images/Group 22.png",
                                  width: screenWidth * (100 / 360),
                                  height: screenHeight * (100 / 800),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        Expanded(
                          child: GridView.builder(
                              itemCount: khatmaParts.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5,mainAxisSpacing: 20,crossAxisSpacing: 12,mainAxisExtent:70 ),
                              itemBuilder: (context,index){
                                final part = khatmaParts[index];
                                return GestureDetector(
                                  onTap: (){
                                    context.read<KhatmatBloc>().add(
                                      UpdateKhatmaPartStatus(
                                        khatmaPart: part.copyWith(
                                          isCompleted: !part.isCompleted,
                                          completedAt: !part.isCompleted ? DateTime.now() : null,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 55,
                                    height: 65,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: part.isCompleted ? AppColors.lightBackground : const Color(0xffD5D5D5),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.4),
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Center(child: Text(part.partNumber.toString(),style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.darkBrown,
                                    ),
                                    ),
                                    ),
                                  ),
                                );
                              }
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else if (state is KhatmatError) {
              return Center(child: Text('خطأ: ${state.message}'));
            }
            return const Center(child: Text('لا يوجد بيانات لعرضها.'));
          },
        ),
      ),
    );
  }
}