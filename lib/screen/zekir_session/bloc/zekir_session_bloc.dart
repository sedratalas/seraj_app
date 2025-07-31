// // lib/bloc/zekir_session_bloc.dart
// import 'package:bloc/bloc.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../../../model/zekir_session_model.dart';
// import 'zekir_session_event.dart';
// import 'zekir_session_state.dart';
//
// class ZekirSessionBloc extends Bloc<ZekirSessionEvent, ZekirSessionState> {
//   ZekirSessionBloc() : super(ZekirSessionInitial()) {
//
//     on<LoadZekirSessions>(_onLoadZekirSessions);
//     on<AddZekirSession>(_onAddZekirSession);
//   }
//
//   final SupabaseClient _supabaseClient = Supabase.instance.client;
//
//   Future<void> _onLoadZekirSessions(
//       LoadZekirSessions event, Emitter<ZekirSessionState> emit) async {
//     emit(ZekirSessionLoading());
//     try {
//       final List<Map<String, dynamic>> response = await _supabaseClient
//           .from('zekir_sessions')
//           .select()
//           .order('created_at', ascending: false);
//
//       final List<ZekirSession> sessions =
//       response.map((map) => ZekirSession.fromMap(map)).toList();
//
//       emit(ZekirSessionLoaded(sessions));
//     } catch (e) {
//       emit(ZekirSessionError('فشل في جلب الجلسات: ${e.toString()}'));
//     }
//   }
//
//   Future<void> _onAddZekirSession(
//       AddZekirSession event, Emitter<ZekirSessionState> emit) async {
//     emit(ZekirSessionAdding());
//     try {
//       await _supabaseClient.from('zekir_sessions').insert(event.session.toMap());
//
//       emit(ZekirSessionAdded());
//       add(LoadZekirSessions());
//     } catch (e) {
//       emit(ZekirSessionError('فشل في إضافة الجلسة: ${e.toString()}'));
//     }
//   }
// }
import 'package:bloc/bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../model/zekir_session_model.dart';
import '../../../service/public_zekir_service.dart';
import 'zekir_session_event.dart';
import 'zekir_session_state.dart';

class ZekirSessionBloc extends Bloc<ZekirSessionEvent, ZekirSessionState> {
  ZekirSessionBloc() : super(ZekirSessionInitial()) {
    on<LoadZekirSessions>(_onLoadZekirSessions);
    on<AddZekirSession>(_onAddZekirSession);
    on<AddZekirSessionWithParticipants>(_onAddZekirSessionWithParticipants);
  }

  final SupabaseClient _supabaseClient = Supabase.instance.client;
  final ZekirSessionService _zekirSessionService = ZekirSessionService();

  Future<void> _onLoadZekirSessions(
      LoadZekirSessions event, Emitter<ZekirSessionState> emit) async {
    emit(ZekirSessionLoading());
    try {
      final List<Map<String, dynamic>> response = await _supabaseClient
          .from('zekir_sessions')
          .select()
          .order('created_at', ascending: false);

      final List<ZekirSession> sessions =
      response.map((map) => ZekirSession.fromMap(map)).toList();

      emit(ZekirSessionLoaded(sessions));
    } catch (e) {
      emit(ZekirSessionError('فشل في جلب الجلسات: ${e.toString()}'));
    }
  }

  Future<void> _onAddZekirSession(
      AddZekirSession event, Emitter<ZekirSessionState> emit) async {
    emit(ZekirSessionAdding());
    try {
      final ZekirSession createdSession = await _zekirSessionService.addZekirSession(event.session);

      emit(ZekirSessionAdded(createdSession));
      add(LoadZekirSessions());
    } catch (e) {
      emit(ZekirSessionError('فشل في إضافة الجلسة: ${e.toString()}'));
    }
  }

  Future<void> _onAddZekirSessionWithParticipants(
      AddZekirSessionWithParticipants event, Emitter<ZekirSessionState> emit) async {
    emit(ZekirSessionAdding());
    try {
      final ZekirSession createdSession = await _zekirSessionService.addZekirSession(event.session);

      final int durationInDays = event.session.endDate.difference(event.session.startDate).inDays + 1;

      final List<Map<String, dynamic>> distributionResult = await _zekirSessionService.distributeZekir(
        createdSession.id!,
        createdSession.dhikrType,
        createdSession.requiredCount,
        durationInDays,
        event.participantNames,
      );

      emit(ZekirSessionAdded(createdSession, distributionResult: distributionResult));
      add(LoadZekirSessions());
    } catch (e) {
      emit(ZekirSessionError('فشل في إضافة الجلسة وتوزيعها: ${e.toString()}'));
    }
  }
}