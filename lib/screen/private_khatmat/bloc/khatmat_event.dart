import 'package:equatable/equatable.dart';
import 'package:seraj_app/model/private_khatma_model.dart';

import '../../../model/privat_parts_model.dart';

abstract class KhatmatEvent extends Equatable{
  const KhatmatEvent();
  @override
  List<Object> get props => [];
}
class LoadKhatmat extends KhatmatEvent{}
class AddKhatma extends KhatmatEvent{
  final KhatmaModel khatma;

  AddKhatma({required this.khatma});
  @override
  List<Object> get props => [khatma];
}

class LoadKhatmaParts extends KhatmatEvent {
  final String khatmaId;
  const LoadKhatmaParts({required this.khatmaId});
  @override
  List<Object> get props => [khatmaId];
}

class UpdateKhatmaPartStatus extends KhatmatEvent {
  final KhatmaPartModel khatmaPart;
  const UpdateKhatmaPartStatus({required this.khatmaPart});
  @override
  List<Object> get props => [khatmaPart];
}