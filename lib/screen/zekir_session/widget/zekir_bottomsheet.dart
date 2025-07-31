// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:seraj_app/core/utils/color_manager.dart';
// import 'package:intl/intl.dart';
// import 'package:seraj_app/model/zekir_session_model.dart';
//
// import '../bloc/zekir_session_bloc.dart';
// import '../bloc/zekir_session_event.dart';
// import '../bloc/zekir_session_state.dart';
//
// class DhikrInputBottomSheet extends StatefulWidget {
//   const DhikrInputBottomSheet({Key? key}) : super(key: key);
//
//   @override
//   State<DhikrInputBottomSheet> createState() => _DhikrInputBottomSheetState();
// }
//
// class _DhikrInputBottomSheetState extends State<DhikrInputBottomSheet> {
//   String? _selectedDhikr;
//   DateTimeRange? _selectedDateRange;
//   double _requiredCount = 300.0;
//   final List<String> _dhikrOptions = [
//     'استغفار',
//     'صلاة عالنبي',
//     'حوقلة',
//     'بسملة',
//     'تهليل',
//     'تكبير',
//     'تسبيح',
//   ];
//   late double screenWidth;
//   late double screenHeight;
//
//   @override
//   Widget build(BuildContext context) {
//     screenWidth =MediaQuery.sizeOf(context).width;
//     screenHeight = MediaQuery.sizeOf(context).height;
//     return BlocListener<ZekirSessionBloc,ZekirSessionState>(
//       listener: (context,state) {
//         if (state is ZekirSessionAdded) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('تم إضافة جلسة الذكر بنجاح!')),
//           );
//           Navigator.pop(context);
//         } else if (state is ZekirSessionError) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('حدث خطأ: ${state.message}')),
//           );
//         }
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: AppColors.darkBrown,
//           borderRadius: BorderRadius.only(topLeft: Radius.circular(35),topRight: Radius.circular(35)),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(50.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Text("الذكر",
//                 style: TextStyle(
//                   color: Colors.white,
//                 ),
//                 textAlign: TextAlign.right,),
//               const SizedBox(height: 8),
//               _buildDhikrDropdown(),
//               const SizedBox(height: 20),
//               Text(
//                   'مدة الختمة',
//                   style: TextStyle(
//                     color: Colors.white,
//                   ),
//                   textAlign: TextAlign.right,
//                 ),
//                 const SizedBox(height: 8),
//                 _buildDateRangeField(),
//                 const SizedBox(height: 20),
//               Text(
//                 'العدد المفروض',
//                 style: TextStyle(
//                   color: Colors.white,
//                 ),
//                 textAlign: TextAlign.right,
//               ),
//               _buildCountSlider(),
//               Image.asset("assets/images/img_2.png"),
//               GestureDetector(
//                 onTap: (){
//                   if (_selectedDhikr == null || _selectedDateRange == null) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('الرجاء ملء جميع الحقول المطلوبة!')),
//                     );
//                     return;
//                   }
//                   final newSession = ZekirSession(
//                       dhikrType: _selectedDhikr!,
//                       startDate: _selectedDateRange!.start,
//                       endDate: _selectedDateRange!.end,
//                       requiredCount: _requiredCount.round(),
//                     completedCount: 0,
//                   );
//                   context.read<ZekirSessionBloc>().add(AddZekirSession(newSession));
//                 },
//                 child: Container(
//                   height: screenHeight *(41/800),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: AppColors.lightBackground,
//                   ),
//                   child: Center(
//                     child: BlocBuilder<ZekirSessionBloc, ZekirSessionState>(
//                     builder: (context,state) {
//                       return state is ZekirSessionAdding
//                         ? const CircularProgressIndicator(color: Colors.white)
//                         : Text("إضافة", style: TextStyle(
//                         fontSize: 25,
//                         fontWeight: FontWeight.w400,
//                       ),
//                       );
//                     }
//                   ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDhikrDropdown() {
//     return DropdownButtonFormField<String>(
//       decoration: InputDecoration(
//           filled: true,
//           fillColor: Colors.white,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8.0),
//             borderSide: BorderSide.none,
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8.0),
//             borderSide: BorderSide.none,
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8.0),
//             borderSide: const BorderSide(color: Colors.white, width: 1.0),
//           ),
//           hintStyle: TextStyle(color: Colors.white54),
//           labelStyle: TextStyle(color: Colors.white),
//         ),
//       value: _selectedDhikr,
//       icon: const Icon(Icons.arrow_drop_down, color: AppColors.darkBrown),
//       style: TextStyle(color: AppColors.darkBrown),
//         dropdownColor: Color(0xffD9D9D9),
//       items: _dhikrOptions.map((String dhikr) {
//         return DropdownMenuItem<String>(
//           value: dhikr,
//           child: Align(
//               alignment: Alignment.centerRight,
//               child: Text(dhikr,textAlign: TextAlign.right,)),
//         );
//       }).toList(),
//       onChanged: (String? newValue) {
//         setState(() {
//           _selectedDhikr = newValue;
//         });
//       }
//     );
//
//   }
//   Widget _buildDateRangeField() {
//     return GestureDetector(
//       onTap: _pickDateRange,
//       child: AbsorbPointer(
//         child: TextFormField(
//           controller: TextEditingController(
//             text: _selectedDateRange == null
//                 ? ''
//                 : '${DateFormat('d-M-yyyy').format(_selectedDateRange!.start)} | ${DateFormat('d-M-yyyy').format(_selectedDateRange!.end)}',
//           ),
//           decoration: InputDecoration(
//             filled: true,
//             fillColor: Colors.white,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8.0),
//               borderSide: BorderSide.none,
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8.0),
//               borderSide: BorderSide.none,
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8.0),
//               borderSide: const BorderSide(color: Colors.white, width: 1.0),
//             ),
//             hintStyle: TextStyle(color: Colors.white54),
//             labelStyle: TextStyle(color: Colors.white),
//           ),
//           readOnly: true,
//         ),
//       ),
//     );
//   }
//
//   Future<void> _pickDateRange() async {
//     DateTimeRange? picked = await showDateRangePicker(
//       context: context,
//       firstDate: DateTime(2020), // حسب الصورة
//       lastDate: DateTime(2030),
//       initialDateRange: _selectedDateRange,
//       builder: (BuildContext context, Widget? child) {
//         return Theme(
//           data: ThemeData.light().copyWith(
//             primaryColor: Theme.of(context).colorScheme.primary, // لون التحديد في التقويم
//             colorScheme: ColorScheme.light(
//               primary: Theme.of(context).colorScheme.primary, // لون الرأس في التقويم
//               onPrimary: Colors.white, // لون النص في الرأس
//               surface: Colors.white, // لون خلفية التقويم
//               onSurface: Colors.black, // لون النص في التقويم
//             ),
//             dialogBackgroundColor: Colors.white,
//           ),
//           child: child!,
//         );
//       },
//     );
//
//     if (picked != null && picked != _selectedDateRange) {
//       setState(() {
//         _selectedDateRange = picked;
//       });
//     }
//   }
//
//   Widget _buildCountSlider() {
//     return Column(
//       children: [
//         Slider(
//           value: _requiredCount,
//           min: 0,
//           max: 10000,
//           divisions: 100,
//           label: _requiredCount.round().toString(),
//           activeColor: Theme.of(context).colorScheme.secondary,
//           inactiveColor: AppColors.lightBackground,
//           onChanged: (double newValue) {
//             setState(() {
//               _requiredCount = newValue;
//             });
//           },
//         ),
//         Align(
//           alignment: Alignment.centerRight,
//           child: Text(
//             '${_requiredCount.round()}',
//             style: Theme.of(context).textTheme.bodyMedium,
//           ),
//         ),
//       ],
//     );
//   }
//
//
// }
//
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seraj_app/core/utils/color_manager.dart';
import 'package:intl/intl.dart';
import 'package:seraj_app/model/zekir_session_model.dart';

import '../bloc/zekir_session_bloc.dart';
import '../bloc/zekir_session_event.dart';
import '../bloc/zekir_session_state.dart';
import 'add_zekir_participant.dart';

class DhikrInputBottomSheet extends StatefulWidget {
  const DhikrInputBottomSheet({Key? key}) : super(key: key);

  @override
  State<DhikrInputBottomSheet> createState() => _DhikrInputBottomSheetState();
}

class _DhikrInputBottomSheetState extends State<DhikrInputBottomSheet> {
  String? _selectedDhikr;
  DateTimeRange? _selectedDateRange;
  double _requiredCount = 300.0;
  final List<String> _dhikrOptions = [
    'استغفار',
    'صلاة عالنبي',
    'حوقلة',
    'بسملة',
    'تهليل',
    'تكبير',
    'تسبيح',
  ];
  late double screenWidth;
  late double screenHeight;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.sizeOf(context).width;
    screenHeight = MediaQuery.sizeOf(context).height;
    return BlocListener<ZekirSessionBloc, ZekirSessionState>(
      listener: (context, state) {
        if (state is ZekirSessionAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم إضافة جلسة الذكر بنجاح!')),
          );
          Navigator.pop(context);
        } else if (state is ZekirSessionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('حدث خطأ: ${state.message}')),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.darkBrown,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "الذكر",
                style: TextStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 8),
              _buildDhikrDropdown(),
              const SizedBox(height: 20),
              Text(
                'مدة الختمة',
                style: TextStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 8),
              _buildDateRangeField(),
              const SizedBox(height: 20),
              Text(
                'العدد المفروض',
                style: TextStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.right,
              ),
              _buildCountSlider(),
              GestureDetector(
                onTap: () {
                  if (_selectedDhikr == null || _selectedDateRange == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('الرجاء ملء جميع الحقول المطلوبة!')),
                    );
                    return;
                  }
                  _proceedToParticipants();
                },
                child: Container(
                  height: screenHeight * (41 / 800),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.lightBackground,
                  ),
                  child: Center(
                    child: BlocBuilder<ZekirSessionBloc, ZekirSessionState>(
                      builder: (context, state) {
                        return state is ZekirSessionAdding
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                          "إضافة",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w400,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDhikrDropdown() {
    return DropdownButtonFormField<String>(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.white, width: 1.0),
          ),
          hintStyle: TextStyle(color: Colors.white54),
          labelStyle: TextStyle(color: Colors.white),
        ),
        value: _selectedDhikr,
        icon: const Icon(Icons.arrow_drop_down, color: AppColors.darkBrown),
        style: TextStyle(color: AppColors.darkBrown),
        dropdownColor: Color(0xffD9D9D9),
        items: _dhikrOptions.map((String dhikr) {
          return DropdownMenuItem<String>(
            value: dhikr,
            child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  dhikr,
                  textAlign: TextAlign.right,
                )),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedDhikr = newValue;
          });
        });
  }

  Widget _buildDateRangeField() {
    return GestureDetector(
      onTap: _pickDateRange,
      child: AbsorbPointer(
        child: TextFormField(
          controller: TextEditingController(
            text: _selectedDateRange == null
                ? ''
                : '${DateFormat('d-M-yyyy').format(_selectedDateRange!.start)} | ${DateFormat('d-M-yyyy').format(_selectedDateRange!.end)}',
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Colors.white, width: 1.0),
            ),
            hintStyle: TextStyle(color: Colors.white54),
            labelStyle: TextStyle(color: Colors.white),
          ),
          readOnly: true,
        ),
      ),
    );
  }

  Future<void> _pickDateRange() async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDateRange: _selectedDateRange,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Theme.of(context).colorScheme.primary,
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  Widget _buildCountSlider() {
    return Column(
      children: [
        Slider(
          value: _requiredCount,
          min: 0,
          max: 10000,
          divisions: 100,
          label: _requiredCount.round().toString(),
          activeColor: Theme.of(context).colorScheme.secondary,
          inactiveColor: AppColors.lightBackground,
          onChanged: (double newValue) {
            setState(() {
              _requiredCount = newValue;
            });
          },
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '${_requiredCount.round()}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  void _proceedToParticipants() async {
    final newSession = ZekirSession(
      dhikrType: _selectedDhikr!,
      startDate: _selectedDateRange!.start,
      endDate: _selectedDateRange!.end,
      requiredCount: _requiredCount.round(),
      completedCount: 0,
    );

    final bool? result = await showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack,
          ),
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return AddZekirParticipantScreen(zekirSession: newSession);
      },
    );

    if (result == true) {
      Navigator.pop(context);
    }
  }
}