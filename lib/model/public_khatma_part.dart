import 'package:equatable/equatable.dart';

class KhatmaPart extends Equatable {
  final String id;
  final int partNumber;
  final String participantName;
  final DateTime readDate;
  final bool isCompleted;
  final DateTime? completedAt;
  final String khatmaId;
  final String participantId;

  const KhatmaPart({
    required this.id,
    required this.partNumber,
    required this.participantName,
    required this.readDate,
    required this.isCompleted,
    this.completedAt,
    required this.khatmaId,
    required this.participantId,
  });

  factory KhatmaPart.fromJson(Map<String, dynamic> json) {
    final participantData = json['publicparticipants'] as Map<String, dynamic>;
    final String name = participantData['name'] as String;

    return KhatmaPart(
      id: json['id'] as String,
      partNumber: json['part_number'] as int,
      participantName: name,
      readDate: DateTime.parse(json['read_date'] as String),
      isCompleted: json['is_read'] as bool,
      completedAt: json['read_at'] != null ? DateTime.parse(json['read_at'] as String) : null,
      khatmaId: json['khatma_id'] as String,
      participantId: json['participant_id'] as String,
    );
  }

  KhatmaPart copyWith({
    String? id,
    int? partNumber,
    String? participantName,
    DateTime? readDate,
    bool? isCompleted,
    DateTime? completedAt,
    String? khatmaId,
    String? participantId,
  }) {
    return KhatmaPart(
      id: id ?? this.id,
      partNumber: partNumber ?? this.partNumber,
      participantName: participantName ?? this.participantName,
      readDate: readDate ?? this.readDate,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      khatmaId: khatmaId ?? this.khatmaId,
      participantId: participantId ?? this.participantId,
    );
  }

  @override
  List<Object?> get props => [
    id,
    partNumber,
    participantName,
    readDate,
    isCompleted,
    completedAt,
    khatmaId,
    participantId,
  ];
}