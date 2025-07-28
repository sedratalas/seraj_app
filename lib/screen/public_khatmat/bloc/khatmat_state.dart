// import 'package:equatable/equatable.dart';
// import 'package:seraj_app/screen/public_khatmat/bloc/khatmat_event.dart';
//
// import '../../../model/public_khatma_model.dart';
// import '../../../model/public_khatma_part.dart';
//
// abstract class KhatmatState extends Equatable{
//   const KhatmatState();
//
//   @override
//   List<Object?> get props => [];
//
// }
// class KhatmatInitial extends KhatmatState{}
//
// class LoadingKhatmat extends KhatmatState{}
//
// class LoadedKhatmat extends KhatmatState{
//   final List<KhatmaModel> khatmat;
//   const LoadedKhatmat(this.khatmat);
//   @override
//   List<Object> get props => [khatmat];
// }
// class AddingKhatma extends KhatmatState {
// }
// class KhatmaAdded extends KhatmatState {
//   final List<Map<String, dynamic>>? distributionResult;
//   const KhatmaAdded({this.distributionResult});
//
//   @override
//   List<Object?> get props => [distributionResult];
// }
// class KhatmaDistributionLoaded extends KhatmatState {
//   final List<Map<String, dynamic>> distributionResult;
//
//   const KhatmaDistributionLoaded({required this.distributionResult});
//
//   @override
//   List<Object> get props => [distributionResult];
// }
//
// class LoadingKhatmaParts extends KhatmatState {}
//
// class LoadedKhatmaParts extends KhatmatState {
//   final List<KhatmaPart> khatmaParts;
//   const LoadedKhatmaParts(this.khatmaParts);
//   @override
//   List<Object> get props => [khatmaParts];
// }
//
// class KhatmatError extends KhatmatState {
//   final String message;
//   final KhatmatEvent? sourceEvent;
//
//   const KhatmatError(this.message, {this.sourceEvent});
//
//   @override
//   List<Object> get props => [message, sourceEvent ?? ''];
// }
// class KhatmaDistributionLoading extends KhatmatState {}
import 'package:equatable/equatable.dart';
import 'package:seraj_app/screen/public_khatmat/bloc/khatmat_event.dart';

import '../../../model/public_khatma_model.dart';
import '../../../model/public_khatma_part.dart';

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
  List<Object?> get props => [khatmat];
}

class AddingKhatma extends KhatmatState {}

class KhatmaAdded extends KhatmatState {
  final List<Map<String, dynamic>>? distributionResult;
  const KhatmaAdded({this.distributionResult});

  @override
  List<Object?> get props => [distributionResult];
}

class KhatmaDistributionLoading extends KhatmatState {}

class KhatmaDistributionLoaded extends KhatmatState {
  final List<Map<String, dynamic>> distributionResult;
  final String khatmaId;
  final DateTime targetDate;

  const KhatmaDistributionLoaded({
    required this.distributionResult,
    required this.khatmaId,
    required this.targetDate,
  });

  @override
  List<Object?> get props => [distributionResult, khatmaId, targetDate];
}

class LoadingKhatmaParts extends KhatmatState {}

class LoadedKhatmaParts extends KhatmatState {
  final List<KhatmaPart> khatmaParts;
  const LoadedKhatmaParts(this.khatmaParts);
  @override
  List<Object?> get props => [khatmaParts];
}

class KhatmatError extends KhatmatState {
  final String message;
  final KhatmatEvent? sourceEvent;

  const KhatmatError(this.message, {this.sourceEvent});

  @override
  List<Object?> get props => [message, sourceEvent];
}