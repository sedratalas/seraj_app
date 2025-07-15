import 'package:equatable/equatable.dart';

class KhatmaModel extends Equatable {
  final String? id;
  final String intention;
  final DateTime startDate;
  final DateTime endDate;
  final int durationDay;
  final bool isFajr;
  final bool isPriority;
  final DateTime? createdAt;

  const KhatmaModel({
    this.id,
    required this.intention,
    required this.startDate,
    required this.endDate,
    required this.durationDay,
    this.isFajr = false,
    this.isPriority = false,
    this.createdAt,
  });

  factory KhatmaModel.fromMap(Map<String, dynamic> map) {
    return KhatmaModel(
      id: map['id'],
      intention: map['intention'],
      startDate: DateTime.parse(map['start_date']),
      endDate: DateTime.parse(map['end_date']),
      durationDay: map['duration_day'] as int,
      isFajr: map['is_fajr'] ?? false,
      isPriority: map['is_priority'] ?? false,
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'intention': intention,
      'start_date': startDate.toIso8601String().split('T')[0],
      'end_date': endDate.toIso8601String().split('T')[0],
      'duration_day': durationDay,
      'is_fajr': isFajr,
      'is_priority': isPriority,
    };
  }

  @override
  List<Object?> get props => [
    id,
    intention,
    startDate,
    endDate,
    durationDay,
    isFajr,
    isPriority,
    createdAt,
  ];
}