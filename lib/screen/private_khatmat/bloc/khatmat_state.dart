import 'package:equatable/equatable.dart';
import 'package:seraj_app/model/private_khatma_model.dart';

import '../../../model/privat_parts_model.dart';

abstract class KhatmatState extends Equatable{
  const KhatmatState();

  @override
  List<Object> get props => [];

}
class KhatmatInitial extends KhatmatState{}

class LoadingKhatmat extends KhatmatState{}

class LoadedKhatmat extends KhatmatState{
  final List<KhatmaModel> khatmat;
  const LoadedKhatmat(this.khatmat);
  @override
  List<Object> get props => [khatmat];
}

class KhatmatError extends KhatmatState {
final String message;
const KhatmatError(this.message);

@override
List<Object> get props => [message];
}
class LoadingKhatmaParts extends KhatmatState {}

class LoadedKhatmaParts extends KhatmatState {
  final List<KhatmaPartModel> khatmaParts;
  const LoadedKhatmaParts({required this.khatmaParts});
  @override
  List<Object> get props => [khatmaParts];
}
class AddingKhatma extends KhatmatState {}
class KhatmaAdded extends KhatmatState {}
class UpdatingKhatmaPartStatus extends KhatmatState {}

class KhatmaPartStatusUpdated extends KhatmatState {}