// import 'package:equatable/equatable.dart';
//
// class KhatmaModel extends Equatable {
//   final String? id;
//   final String intention;
//   final DateTime startDate;
//   final DateTime endDate;
//   final num durationDay;
//   final bool isFajr;
//   final bool isPriority;
//   final DateTime? createdAt;
//
//   const KhatmaModel({
//     this.id,
//     required this.intention,
//     required this.startDate,
//     required this.endDate,
//     required this.durationDay,
//     this.isFajr = false,
//     this.isPriority = false,
//     this.createdAt,
//   });
//
//   factory KhatmaModel.fromMap(Map<String, dynamic> map) {
//     return KhatmaModel(
//       id: map['id'],
//       intention: map['intention'],
//       startDate: DateTime.parse(map['start_date']),
//       endDate: DateTime.parse(map['end_date']),
//       durationDay: map['duration_day'] ,
//       isFajr: map['is_fajr'] ?? false,
//       isPriority: map['is_priority'] ?? false,
//       createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'intention': intention,
//       'start_date': startDate.toIso8601String().split('T')[0],
//       'end_date': endDate.toIso8601String().split('T')[0],
//       'duration_day': durationDay,
//       'is_fajr': isFajr,
//       'is_priority': isPriority,
//     };
//   }
//
//   @override
//   List<Object?> get props => [
//     id,
//     intention,
//     startDate,
//     endDate,
//     durationDay,
//     isFajr,
//     isPriority,
//     createdAt,
//   ];
// }import 'package:equatable/equatable.dart';
// import 'package:uuid/uuid.dart';
//
// class KhatmaModel extends Equatable {
//   final String id;
//   final String intention;
//   final DateTime startDate;
//   final DateTime endDate;
//   final num durationDay;
//   final bool isFajr;
//   final bool isPriority;
//   final DateTime createdAt;
//
//   KhatmaModel({
//     String? id,
//     required this.intention,
//     required this.startDate,
//     required this.endDate,
//     required this.durationDay,
//     this.isFajr = false,
//     this.isPriority = false,
//     DateTime? createdAt,
//   })  : id = id ?? const Uuid().v4(),
//         createdAt = createdAt ?? DateTime.now();
//
//   factory KhatmaModel.fromMap(Map<String, dynamic> map) {
//     return KhatmaModel(
//       id: map['id'] as String,
//       intention: map['intention'] as String,
//       startDate: DateTime.parse(map['start_date'] as String),
//       endDate: DateTime.parse(map['end_date'] as String),
//       durationDay: map['duration_day'] as num,
//       isFajr: map['is_fajr'] as bool? ?? false,
//       isPriority: map['is_priority'] as bool? ?? false,
//       createdAt: DateTime.parse(map['created_at'] as String),
//     );
//   }
//
//   @override
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'intention': intention,
//       'start_date': startDate.toIso8601String().split('T')[0],
//       'end_date': endDate.toIso8601String().split('T')[0],
//       'duration_day': durationDay,
//       'is_fajr': isFajr,
//       'is_priority': isPriority,
//       'created_at': createdAt.toIso8601String(),
//     };
//   }
//
//   @override
//   List<Object?> get props => [
//         id,
//         intention,
//         startDate,
//         endDate,
//         durationDay,
//         isFajr,
//         isPriority,
//         createdAt,
//       ];
// }
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class KhatmaModel extends Equatable {
  final String id;
  final String intention;
  final DateTime startDate;
  final DateTime endDate;
  final num durationDay;
  final bool isFajr;
  final bool isPriority;
  final DateTime createdAt;

  KhatmaModel({
    String? id,
    required this.intention,
    required this.startDate,
    required this.endDate,
    required this.durationDay,
    this.isFajr = false,
    this.isPriority = false,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  factory KhatmaModel.fromMap(Map<String, dynamic> map) {
    return KhatmaModel(
      id: map['id'] as String,
      intention: map['intention'] as String,
      startDate: DateTime.parse(map['start_date'] as String),
      endDate: DateTime.parse(map['end_date'] as String),
      durationDay: map['duration_day'] as num,
      isFajr: map['is_fajr'] as bool? ?? false,
      isPriority: map['is_priority'] as bool? ?? false,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'intention': intention,
      'start_date': startDate.toIso8601String().split('T')[0],
      'end_date': endDate.toIso8601String().split('T')[0],
      'duration_day': durationDay,
      'is_fajr': isFajr,
      'is_priority': isPriority,
      'created_at': createdAt.toIso8601String(),
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