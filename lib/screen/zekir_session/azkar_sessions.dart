import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seraj_app/core/utils/color_manager.dart';
import 'package:seraj_app/screen/zekir_session/widget/zekir_card.dart';

import 'bloc/zekir_session_bloc.dart';
import 'bloc/zekir_session_event.dart';
import 'bloc/zekir_session_state.dart';
import 'widget/zekir_bottomsheet.dart';


class AzkarSessions extends StatefulWidget {
  const AzkarSessions({Key? key}) : super(key: key);

  @override

  State<AzkarSessions> createState() => _AzkarSessionsState();

}

class _AzkarSessionsState extends State<AzkarSessions> {
  void initState() {
    super.initState();
    context.read<ZekirSessionBloc>().add(LoadZekirSessions());
  }
  @override
  late double screenWidth;
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/splash (1).png",),
              fit: BoxFit.fill
          ),
        ),

        child: BlocBuilder<ZekirSessionBloc, ZekirSessionState>(
          builder: (context, state) {
            if (state is ZekirSessionLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ZekirSessionError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is ZekirSessionLoaded) {
              if (state.sessions.isEmpty) {
                return const Center(child: Text('لا توجد جلسات ذكر حتى الآن.'));
              }
              return SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding:  EdgeInsets.only(left: screenWidth*(20/300),right:screenWidth*(20/300) ),
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
                                Image.asset("assets/images/left_floral.png"),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: const Text("جلسات الذكر",style: TextStyle(fontSize: 30,color: AppColors.darkBrown, fontFamily: "H-ALHFHAF",),),
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
                        itemCount: state.sessions.length,
                        itemBuilder: (context, index) {
                          final session = state.sessions[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25),
                            child: ZekirCard(
                              dhikrType: session.dhikrType,
                              startDate: session.startDate,
                              endDate: session.endDate,
                              requiredCount: session.requiredCount,
                              completedCount: session.completedCount,
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
            _showDhikrBottomSheet(context);
          },
          child: Icon(Icons.add, color: Colors.white,),
      ),
    );
  }
  void _showDhikrBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: const DhikrInputBottomSheet(),
        );
      },
    );
  }
}
