
import 'package:equatable/equatable.dart';

import '../../../model/public_khatma_model.dart';

abstract class KhatmatEvent extends Equatable{
  const KhatmatEvent();
  @override
  List<Object?> get props => [];
}

class LoadKhatmat extends KhatmatEvent{}

class AddKhatma extends KhatmatEvent{
  final KhatmaModel khatma;
  final List<String> participantNames;

  AddKhatma({required this.khatma, required this.participantNames});
  @override
  List<Object?> get props => [khatma,participantNames];
}

class GetKhatmaDistributionForDate extends KhatmatEvent {
  final String khatmaId;
  final DateTime targetDate;

  const GetKhatmaDistributionForDate({required this.khatmaId, required this.targetDate});

  @override
  List<Object?> get props => [khatmaId, targetDate];
}

class LoadKhatmaParts extends KhatmatEvent {
  final String khatmaId;
  const LoadKhatmaParts({required this.khatmaId});
  @override
  List<Object?> get props => [khatmaId];
}

class MarkKhatmaPartsAsRead extends KhatmatEvent {
  final String khatmaId;
  final DateTime targetDate;

  const MarkKhatmaPartsAsRead({required this.khatmaId, required this.targetDate});

  @override
  List<Object?> get props => [khatmaId, targetDate];
}