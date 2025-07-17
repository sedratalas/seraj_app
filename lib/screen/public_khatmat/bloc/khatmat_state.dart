import 'package:equatable/equatable.dart';
import 'package:seraj_app/screen/public_khatmat/bloc/khatmat_event.dart';


import '../../../model/privat_parts_model.dart';
import '../../../model/public_khatma_model.dart';

abstract class KhatmatState extends Equatable{
  const KhatmatState();

  @override
  List<Object?> get props => [];

}
class KhatmatInitial extends KhatmatState{}

class LoadingKhatmat extends KhatmatState{}

class LoadedKhatmat extends KhatmatState{
  final List<KhatmaModel> khatmat;
  const LoadedKhatmat(this.khatmat);
  @override
  List<Object> get props => [khatmat];
}
class AddingKhatma extends KhatmatState {
}
class KhatmaAdded extends KhatmatState {
  final List<Map<String, dynamic>>? distributionResult;
  const KhatmaAdded({this.distributionResult});

  @override
  List<Object?> get props => [distributionResult];
}
class KhatmaDistributionLoaded extends KhatmatState {
  final List<Map<String, dynamic>> distributionResult;

  const KhatmaDistributionLoaded({required this.distributionResult});

  @override
  List<Object> get props => [distributionResult];
}


class KhatmatError extends KhatmatState {
  final String message;
  final KhatmatEvent? sourceEvent;

  const KhatmatError(this.message, {this.sourceEvent});

  @override
  List<Object> get props => [message, sourceEvent ?? ''];
}
// class UpdatingKhatmaPartStatus extends KhatmatState {}
//
// class KhatmaPartStatusUpdated extends KhatmatState {}