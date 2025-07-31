// // lib/bloc/zekir_session_state.dart
// import 'package:equatable/equatable.dart';
//
// import '../../../model/zekir_session_model.dart';
//
//
//
// abstract class ZekirSessionState extends Equatable {
//   const ZekirSessionState();
//
//   @override
//   List<Object> get props => [];
// }
//
// class ZekirSessionInitial extends ZekirSessionState {}
//
// class ZekirSessionLoading extends ZekirSessionState {}
//
// class ZekirSessionLoaded extends ZekirSessionState {
//   final List<ZekirSession> sessions;
//   const ZekirSessionLoaded(this.sessions);
//
//   @override
//   List<Object> get props => [sessions];
// }
//
// class ZekirSessionError extends ZekirSessionState {
//   final String message;
//   const ZekirSessionError(this.message);
//
//   @override
//   List<Object> get props => [message];
// }
//
// class ZekirSessionAdding extends ZekirSessionState {}
//
// class ZekirSessionAdded extends ZekirSessionState {}

import 'package:equatable/equatable.dart';
import '../../../model/zekir_session_model.dart';

abstract class ZekirSessionState extends Equatable {
  const ZekirSessionState();

  @override
  List<Object> get props => [];
}

class ZekirSessionInitial extends ZekirSessionState {}

class ZekirSessionLoading extends ZekirSessionState {}

class ZekirSessionLoaded extends ZekirSessionState {
  final List<ZekirSession> sessions;
  const ZekirSessionLoaded(this.sessions);

  @override
  List<Object> get props => [sessions];
}

class ZekirSessionError extends ZekirSessionState {
  final String message;
  const ZekirSessionError(this.message);

  @override
  List<Object> get props => [message];
}

class ZekirSessionAdding extends ZekirSessionState {}

class ZekirSessionAdded extends ZekirSessionState {
  final ZekirSession createdSession;
  final List<Map<String, dynamic>>? distributionResult;

  const ZekirSessionAdded(this.createdSession, {this.distributionResult});

  @override
  List<Object> get props => [createdSession, distributionResult ?? []];
}