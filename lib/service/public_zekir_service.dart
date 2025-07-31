import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/zekir_session_model.dart';

class ZekirSessionService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<ZekirSession> addZekirSession(ZekirSession session) async {
    final List<Map<String, dynamic>> response = await _supabaseClient
        .from('zekir_sessions')
        .insert(session.toMap())
        .select();

    if (response.isEmpty) {
      throw Exception('Failed to add zekir session: No data returned');
    }
    return ZekirSession.fromMap(response.first);
  }

  Future<List<Map<String, dynamic>>> distributeZekir(
      String sessionId,
      String dhikrType,
      int totalRequiredCount,
      int durationInDays,
      List<String> participantNames,
      ) async {
    if (participantNames.isEmpty) {
      return [];
    }

    final int dailyRequiredCount = (totalRequiredCount / durationInDays).ceil();
    final int countPerPersonPerDay = (dailyRequiredCount / participantNames.length).ceil();

    final List<Map<String, dynamic>> distributionResult = [];
    final List<Map<String, dynamic>> inserts = [];

    for (var i = 0; i < participantNames.length; i++) {
      final name = participantNames[i];
      final assignedCount = countPerPersonPerDay;

      distributionResult.add({
        'participant_name': name,
        'assigned_count': assignedCount,
      });

      inserts.add({
        'session_id': sessionId,
        'participant_name': name,
        'assigned_count': assignedCount,
        'completed_count': 0,
        'date': DateTime.now().toIso8601String(),
      });
    }

    await _supabaseClient.from('zekir_daily_assignments').insert(inserts);

    await _supabaseClient
        .from('zekir_sessions')
        .update({'completed_count': dailyRequiredCount})
        .eq('id', sessionId);

    return distributionResult;
  }
}