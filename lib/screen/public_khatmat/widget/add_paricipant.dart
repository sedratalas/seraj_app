import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/utils/color_manager.dart';
import '../../../model/public_khatma_model.dart';
import '../bloc/khatmat_bloc.dart';
import '../bloc/khatmat_event.dart';
import '../bloc/khatmat_state.dart';

class AddPublicParticipantsScreen extends StatefulWidget {
  final KhatmaModel khatma;

  const AddPublicParticipantsScreen({Key? key, required this.khatma}) : super(key: key);

  @override
  State<AddPublicParticipantsScreen> createState() => _AddPublicParticipantsScreenState();
}

class _AddPublicParticipantsScreenState extends State<AddPublicParticipantsScreen> {
  final TextEditingController _participantNamesController = TextEditingController();
  late double screenWidth;
  late double screenHeight;

  @override
  void dispose() {
    _participantNamesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.sizeOf(context).width;
    screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold( // <--- إضافة Scaffold هنا
      backgroundColor: Colors.transparent, // لجعل الخلفية شفافة أو يمكنك تعيينها حسب تصميمك
      body: BlocListener<PublicKhatmatBloc, KhatmatState>(
        listener: (context, state) {
          if (state is KhatmaAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تمت إضافة الختمة وتوزيع الأجزاء!')),

            );
            if (state.distributionResult != null && state.distributionResult!.isNotEmpty) {
              _shareKhatmaParts(state.distributionResult!);
              print('Distribution Result: ${state.distributionResult}');
            }
            Navigator.pop(context, true);
          } else if (state is KhatmatError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('حدث خطأ: ${state.message}')),
            );
          }
        },
        child: Center( // لجعل الديالوج في المنتصف
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 80.0), // هامش ليعطي شكل الديالوج
            padding: const EdgeInsets.all(25.0),
            decoration: BoxDecoration(
              color: AppColors.darkBrown,
              borderRadius: BorderRadius.circular(20), // حواف مستديرة للديالوج
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // لجعل العمود يأخذ أقل مساحة ممكنة
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.topLeft, // زر الإغلاق في أعلى اليسار
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context); // إغلاق الديالوج
                    },
                  ),
                ),
                Text(
                  "أسماء المشاركين (افصل بفاصلة ,)",
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _participantNamesController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'مثال: أحمد, فاطمة, علي',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                  maxLines: 3,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: _addKhatmaAndShare,
                  child: Container(
                    height: screenHeight * (41 / 800),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.lightBackground,
                    ),
                    child: Center(
                      child: Text(
                        "إضافة ومشاركة",
                        style: TextStyle(
                          color: AppColors.darkBrown,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addKhatmaAndShare() {
    final String namesText = _participantNamesController.text.trim();
    if (namesText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال أسماء المشاركين!')),
      );
      return;
    }

    final List<String> participantNames = namesText
        .split('،').map((name) => name.trim()).where((name) => name.isNotEmpty).toList();

    if (participantNames.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال أسماء مشاركين صحيحة!')),
      );
      return;
    }

    context.read<PublicKhatmatBloc>().add(
      AddKhatma(
        khatma: widget.khatma,
        participantNames: participantNames,
      ),
    );
  }

  void _shareKhatmaParts(List<Map<String, dynamic>> distributionResult) {
    if (distributionResult.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا توجد أجزاء لتتم مشاركتها!')),
      );
      return;
    }

    final String shareText = distributionResult.map((entry) {
      final String name = entry['participant_name'];
      final List<String> parts = List<String>.from(entry['assigned_parts']);
      return 'يا $name، أجزاؤك لليوم هي: ${parts.join(', ')}';
    }).join('\n\n');

    Share.share('ختمة اليوم:\n\n$shareText');
  }
}