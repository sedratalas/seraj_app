import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:seraj_app/screen/public_khatmat/bloc/khatmat_bloc.dart';
import 'package:seraj_app/screen/public_khatmat/bloc/khatmat_event.dart';
import 'package:seraj_app/screen/public_khatmat/bloc/khatmat_state.dart';

import '../../../core/utils/color_manager.dart';
import '../../../model/public_khatma_model.dart';
import 'add_paricipant.dart';


class AddPublicKhatmaScreen extends StatefulWidget {
  const AddPublicKhatmaScreen({Key? key}) : super(key: key);

  @override
  State<AddPublicKhatmaScreen> createState() => _AddPublicKhatmaScreenState();
}

class _AddPublicKhatmaScreenState extends State<AddPublicKhatmaScreen> {
  String? _selectedIntention;
  DateTimeRange? _selectedDateRange;
  bool _isFajr = false;
  bool _isPriority = false;
  final List<String> _dhikrOptions = [
    'قضاء حاجة',
    'تفريج هم',
    'على روح مسلم',
    'شفاء مريض',
    'تيسير أمر',
  ];
  late double screenWidth;
  late double screenHeight;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.sizeOf(context).width;
    screenHeight = MediaQuery.sizeOf(context).height;
    return BlocListener<PublicKhatmatBloc, KhatmatState>(
      listener: (context, state) {
        if (state is KhatmaAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تمت إضافة الختمة بنجاح!')),
          );
          Navigator.pop(context, true);
        } else if (state is KhatmatError) {
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "النية",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 8),
                _buildIntentionDropdown(),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('ذات أولوية', style: TextStyle(color: Colors.white)),
                    Checkbox(
                      value: _isPriority,
                      onChanged: (bool? newValue) {
                        setState(() {
                          _isPriority = newValue ?? false;
                        });
                      },
                      fillColor: WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                            if (states.contains(WidgetState.selected)) {
                              return AppColors.lightBackground;
                            }
                            return Colors.white;
                          }),
                      checkColor: AppColors.darkBrown,
                    ),
                    const SizedBox(width: 20),
                    Text('فجرية', style: TextStyle(color: Colors.white)),
                    Checkbox(
                      value: _isFajr,
                      onChanged: (bool? newValue) {
                        setState(() {
                          _isFajr = newValue ?? false;
                        });
                      },
                      fillColor: WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                            if (states.contains(WidgetState.selected)) {
                              return AppColors.lightBackground;
                            }
                            return Colors.white;
                          }),
                      checkColor: AppColors.darkBrown,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _proceedToParticipants,
                  child: Container(
                    height: screenHeight * (41 / 800),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.lightBackground,
                    ),
                    child: Center(
                      child: Text(
                        "إضافة",
                        style: TextStyle(
                          color: AppColors.darkBrown,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIntentionDropdown() {
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
        value: _selectedIntention,
        icon: const Icon(Icons.arrow_drop_down, color: AppColors.darkBrown),
        style: TextStyle(color: AppColors.darkBrown),
        dropdownColor: const Color(0xffD9D9D9),
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
            _selectedIntention = newValue;
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

  void _proceedToParticipants() async {
    if (_selectedIntention == null || _selectedDateRange == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('الرجاء تعبئة جميع الحقول المطلوبة (النية والمدة)!')),
      );
      return;
    }

    final Duration duration = _selectedDateRange!.end.difference(_selectedDateRange!.start);
    final int durationInDays = duration.inDays + 1;

    final KhatmaModel newKhatma = KhatmaModel(
      intention: _selectedIntention!,
      startDate: _selectedDateRange!.start,
      endDate: _selectedDateRange!.end,
      isFajr: _isFajr,
      isPriority: _isPriority,
      durationDay: durationInDays,
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
        return AddPublicParticipantsScreen(khatma: newKhatma);
      },
    );

    if (result == true) {
      Navigator.pop(context);
    }
  }
}