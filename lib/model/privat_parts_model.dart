// lib/model/khatma_part_model.dart
import 'package:equatable/equatable.dart';

class KhatmaPartModel extends Equatable {
  final String? id;
  final String khatmaId;
  final int partNumber;
  final bool isCompleted;
  final DateTime? completedAt;

  const KhatmaPartModel({
    this.id,
    required this.khatmaId,
    required this.partNumber,
    this.isCompleted = false,
    this.completedAt,
  });

  factory KhatmaPartModel.fromMap(Map<String, dynamic> map) {
    return KhatmaPartModel(
      id: map['id'] as String?,
      khatmaId: map['khatma_id'] as String,
      partNumber: map['part_number'] as int,
      isCompleted: map['is_completed'] as bool? ?? false,
      completedAt: map['completed_at'] != null ? DateTime.parse(map['completed_at']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'khatma_id': khatmaId,
      'part_number': partNumber,
      'is_completed': isCompleted,
      'completed_at': completedAt?.toIso8601String(), // تحويل التاريخ إلى String
    };
  }

  // دالة لإنشاء نسخة جديدة من الموديل مع تغييرات معينة (مفيدة لتحديث الحالة)
  KhatmaPartModel copyWith({
    String? id,
    String? khatmaId,
    int? partNumber,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return KhatmaPartModel(
      id: id ?? this.id,
      khatmaId: khatmaId ?? this.khatmaId,
      partNumber: partNumber ?? this.partNumber,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  List<Object?> get props => [id, khatmaId, partNumber, isCompleted, completedAt];
}