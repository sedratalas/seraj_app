import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seraj_app/core/utils/color_manager.dart';

import '../private_parts_screen.dart';

class KhatmaCard extends StatelessWidget {
  final String id;
  final String intention;
  final DateTime startDate;
  final DateTime endDate;
  final bool isFajr;
  final bool isPriority;
  final String index;

  KhatmaCard({
    Key? key,
    required this.id,
    required this.intention,
    required this.startDate,
    required this.endDate,
    required this.isFajr,
    required this.isPriority,
    required this.index,
  }) : super(key: key);
  late double screenWidth;
  late double screenHeight;
  @override
  Widget build(BuildContext context) {
    screenWidth =MediaQuery.sizeOf(context).width;
    screenHeight = MediaQuery.sizeOf(context).height;
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PrivateKhatmaPartsScreen(
              khatmaId: id,
              khatmaIntention: intention,
              khatmaIndex:index,
            ),
          ),
        );
      },
      child: Container(
        width: screenWidth * (309/360),
        height: screenHeight *(214/800),
        decoration: BoxDecoration(
          color: AppColors.lightBackground,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(intention,style: TextStyle(fontSize: 22,color: AppColors.darkBrown, fontFamily: "H-ALHFHAF",),),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset("assets/images/Group 22.png",
                        width: screenWidth * (100/360),
                        height: screenHeight *(89/800),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 4,),
                          Text("ختمة",style: TextStyle(color: Colors.white),),
                          Text(index,style: TextStyle(color: Colors.white),),

                        ],
                      ),
                    ),
                  ],
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
                _buildDateInfo("تاريخ الانتهاء", DateFormat('d/M/yyyy').format(endDate)),
                Image.asset(
                  "assets/images/floral 7.png",
                  width: screenWidth * (51 / 360),
                  height: screenWidth * (51 / 360) * (28 / 51),
                ),
                _buildDateInfo("تاريخ البدء", DateFormat('d/M/yyyy').format(startDate)),
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
        Text(label, style: const TextStyle(fontSize: 16,color: AppColors.darkBrown, fontFamily: "H-ALHFHAF",),),
        Text(value, style: const TextStyle(fontSize: 18,color: AppColors.darkBrown, fontFamily: "H-ALHFHAF",),),
      ],
    );
  }
}
