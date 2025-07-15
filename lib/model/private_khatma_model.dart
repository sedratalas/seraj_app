import 'package:equatable/equatable.dart';

class KhatmaModel extends Equatable {
  final String? id;
  final String intention;
  final DateTime startDate;
  final DateTime endDate;
  final bool isFajr;
  final bool isPriority;

  const KhatmaModel({
    this.id,
    required this.intention,
    required this.startDate,
    required this.endDate,
    this.isFajr = false,
    this.isPriority = false,
  });

  factory KhatmaModel.fromMap(Map<String, dynamic> map) {
    return KhatmaModel(
      id: map['id'],
      intention: map['intention'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      isFajr: map['isFajr'] ?? false,
      isPriority: map['isPriority'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'intention': intention,
      'startDate': startDate.toIso8601String().split('T')[0],
      'endDate': endDate.toIso8601String().split('T')[0],
      'isFajr': isFajr,
      'isPriority': isPriority,
    };
  }


  @override
  List<Object?> get props => [
    id,
    intention,
    startDate,
    endDate,
    isFajr,
    isPriority,
  ];
}
