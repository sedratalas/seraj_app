import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seraj_app/core/utils/color_manager.dart';

class ZekirCard extends StatelessWidget {
  final String dhikrType;
  final DateTime startDate;
  final DateTime endDate;
  final int requiredCount;
  final int completedCount;
  final String index;

  ZekirCard({
    Key? key,
    required this.dhikrType,
    required this.startDate,
    required this.endDate,
    required this.requiredCount,
    required this.completedCount,
    required this.index,
  }) : super(key: key);
  late double screenWidth;
  late double screenHeight;
  @override
  Widget build(BuildContext context) {
    screenWidth =MediaQuery.sizeOf(context).width;
    screenHeight = MediaQuery.sizeOf(context).height;
    return Container(
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
              Text(dhikrType,style: TextStyle(fontSize: 24,color: AppColors.darkBrown, fontFamily: "H-ALHFHAF",),),
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
                        const SizedBox(height: 4,),
                        const Text("ختمة",style: TextStyle(color: Colors.white),),
                        Text(index,style: TextStyle(color: Colors.white),),

                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  children: [
                    Text("المفروض",style: TextStyle(fontSize: 15,color: AppColors.darkBrown, fontFamily: "H-ALHFHAF",),),
                    Text(requiredCount.toString()),
                  ],
                ),
              ),
              SizedBox(
                width: screenWidth * (51/360),
                height: screenHeight *(28/800),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  children: [
                    Text("المنجز",style: TextStyle(fontSize: 15,color: AppColors.darkBrown, fontFamily: "H-ALHFHAF",),),
                    Text(completedCount.toString()),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateInfo(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 15,color: AppColors.darkBrown, fontFamily: "H-ALHFHAF",),),
        Text(value, style: TextStyle(fontSize: 15,color: AppColors.darkBrown, fontFamily: "H-ALHFHAF",),),
      ],
    );
  }

  Widget _buildCountInfo(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: AppColors.darkBrown, fontSize: 14)),
        Text(value, style: const TextStyle(color: AppColors.darkBrown, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}