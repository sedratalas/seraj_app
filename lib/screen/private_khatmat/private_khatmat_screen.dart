import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seraj_app/core/utils/color_manager.dart';
import 'package:seraj_app/screen/private_khatmat/bloc/khatmat_event.dart';
import 'package:seraj_app/screen/zekir_session/widget/zekir_card.dart';

import '../../providers/theme_notifier.dart';
import 'bloc/khatmat_bloc.dart';
import 'bloc/khatmat_state.dart';
import 'widget/add_privat_khatma.dart';
import 'widget/khatma_card.dart';


class KhatmatScreen extends ConsumerStatefulWidget {
  const KhatmatScreen({Key? key}) : super(key: key);

  @override

  ConsumerState<KhatmatScreen> createState() => _KhatmatScreenState();

}

class _KhatmatScreenState extends ConsumerState<KhatmatScreen> {
  void initState() {
    super.initState();
    context.read<KhatmatBloc>().add(LoadKhatmat());
  }
  @override
  late double screenWidth;
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.sizeOf(context).width;
    final themeState = ref.watch(themeNotifierProvider);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(themeState.currentBackgroundImage,),
              fit: BoxFit.fill
          ),
        ),

        child: BlocBuilder<KhatmatBloc, KhatmatState>(
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
                      padding:  EdgeInsets.only(left: screenWidth*(20/300),right:screenWidth*(20/300), top: 10 ),
                      child: Row(
                        children: [
                          GestureDetector(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Image.asset("assets/images/leftarrow.png")),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(themeState.currentLeftFloralImage),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("الختمات الخاصة",style: TextStyle(fontSize: 28,color: themeState.sirajTextColor, fontFamily: "H-ALHFHAF",),),
                                ),
                                Image.asset(themeState.currentRightFloralImage),
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
                              isFajr:khatma.isFajr,
                              isPriority: khatma.isPriority,
                              index: (index+1).toString(),

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
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.darkBrown,
        onPressed: (){
          _showIntentionBottomSheet(context);
        },
        child: Icon(Icons.add, color: Colors.white,),
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
          child: const AddPrivateKhatmaScreen(),
        );
      },
    );
  }
}
