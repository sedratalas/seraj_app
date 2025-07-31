// // lib/bloc/zekir_session_event.dart
// import 'package:equatable/equatable.dart';
//
// import '../../../model/zekir_session_model.dart';
//
// abstract class ZekirSessionEvent extends Equatable {
//   const ZekirSessionEvent();
//
//   @override
//   List<Object> get props => [];
// }
//
// class LoadZekirSessions extends ZekirSessionEvent {}
//
// class AddZekirSession extends ZekirSessionEvent {
//   final ZekirSession session;
//
//   const AddZekirSession(this.session);
//
//   @override
//   List<Object> get props => [session];
// }
//
import 'package:equatable/equatable.dart';
import '../../../model/zekir_session_model.dart';

abstract class ZekirSessionEvent extends Equatable {
  const ZekirSessionEvent();

  @override
  List<Object> get props => [];
}

class LoadZekirSessions extends ZekirSessionEvent {}

class AddZekirSession extends ZekirSessionEvent {
  final ZekirSession session;
  const AddZekirSession(this.session);
  @override
  List<Object> get props => [session];
}

class AddZekirSessionWithParticipants extends ZekirSessionEvent {
  final ZekirSession session;
  final List<String> participantNames;

  const AddZekirSessionWithParticipants({
    required this.session,
    required this.participantNames,
  });

  @override
  List<Object> get props => [session, participantNames];
}