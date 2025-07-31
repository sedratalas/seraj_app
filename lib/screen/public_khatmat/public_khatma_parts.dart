import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seraj_app/core/utils/color_manager.dart';
import 'package:seraj_app/providers/theme_notifier.dart';
import 'package:seraj_app/screen/public_khatmat/bloc/khatmat_bloc.dart';
import 'package:seraj_app/screen/public_khatmat/bloc/khatmat_event.dart';
import 'package:seraj_app/screen/public_khatmat/bloc/khatmat_state.dart';

class PublicKhatmaPartsScreen extends ConsumerStatefulWidget {
  final String khatmaId;
  final String khatmaIntention;
  final String khatmaindex;

  const PublicKhatmaPartsScreen({
    Key? key,
    required this.khatmaId,
    required this.khatmaIntention,
    required this.khatmaindex,
  }) : super(key: key);

  @override
  ConsumerState<PublicKhatmaPartsScreen> createState() => _PublicKhatmaPartsScreenState();
}

class _PublicKhatmaPartsScreenState extends ConsumerState<PublicKhatmaPartsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PublicKhatmatBloc>().add(LoadKhatmaParts(khatmaId: widget.khatmaId));
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
        context.read<PublicKhatmatBloc>().add(LoadKhatmat());
      },
      child: Scaffold(
        body: BlocBuilder<PublicKhatmatBloc, KhatmatState>(
          builder: (context, state) {
            if (state is LoadingKhatmaParts) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LoadedKhatmaParts) {
              if (state.khatmaParts.isEmpty) {
                return const Center(child: Text('لا توجد أجزاء لهذه الختمة بعد.'));
              }

              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(themeState.currentBackgroundImage),
                    fit: BoxFit.fill,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(left: screenWidth * (20 / 300), right: screenWidth * (20 / 300)),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                context.read<PublicKhatmatBloc>().add(LoadKhatmat());
                                Navigator.pop(context);
                              },
                              child: Image.asset("assets/images/leftarrow.png"),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(themeState.currentLeftFloralImage),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("${widget.khatmaindex}   ختمة " ,style: TextStyle(fontSize: 30,color: themeState.sirajTextColor, fontFamily: "H-ALHFHAF",),),
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
                            itemCount: state.khatmaParts.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 12,
                              mainAxisExtent: 70,
                            ),
                            itemBuilder: (context, index) {
                              final part = state.khatmaParts[index];
                              return Container(
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
                                child: Center(
                                  child: Text(
                                    part.partNumber.toString(),
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.darkBrown,
                                    ),
                                  ),
                                ),
                              );
                            },
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
            return const Center(child: Text('جاري التحميل...'));
          },
        ),
      ),
    );
  }
}