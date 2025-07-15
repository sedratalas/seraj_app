// lib/models/zekir_session.dart
import 'package:equatable/equatable.dart';

class ZekirSession extends Equatable {
  final String? id;
  final String dhikrType;
  final DateTime startDate;
  final DateTime endDate;
  final int requiredCount;
  final int completedCount;

  const ZekirSession({
    this.id,
    required this.dhikrType,
    required this.startDate,
    required this.endDate,
    required this.requiredCount,
    this.completedCount = 0,
  });

  factory ZekirSession.fromMap(Map<String, dynamic> map) {
    return ZekirSession(
      id: map['id'],
      dhikrType: map['dhikr_type'],
      startDate: DateTime.parse(map['start_date']),
      endDate: DateTime.parse(map['end_date']),
      requiredCount: map['required_count'],
      completedCount: map['completed_count'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dhikr_type': dhikrType,
      'start_date': startDate.toIso8601String().split('T')[0],
      'end_date': endDate.toIso8601String().split('T')[0],
      'required_count': requiredCount,
      'completed_count': completedCount,
    };
  }

  @override
  List<Object?> get props => [
    id,
    dhikrType,
    startDate,
    endDate,
    requiredCount,
    completedCount,
  ];
}