import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/public_khatma_model.dart';
import '../model/public_khatma_part.dart';

class PublicKhatmatService {
  final SupabaseClient _supabaseClient;

  PublicKhatmatService(this._supabaseClient);

  Future<List<KhatmaModel>> fetchKhatmat() async {
    final List<Map<String, dynamic>> response = await _supabaseClient
        .from('publickhatmat')
        .select()
        .order('created_at', ascending: false);

    return response.map((map) => KhatmaModel.fromMap(map)).toList();
  }

  Future<List<Map<String, dynamic>>?> addPublicKhatmaAndDistributeParts(KhatmaModel khatma, List<String> participantNames) async {
    try {

      final List<dynamic> response = await _supabaseClient.rpc(
        'create_khatma_and_distribute_parts',
        params: {
          'p_intention': khatma.intention,
          'p_start_date': khatma.startDate.toIso8601String().split('T')[0], // Supabase يحتاج تاريخ بدون وقت
          'p_end_date': khatma.endDate.toIso8601String().split('T')[0],   // Supabase يحتاج تاريخ بدون وقت
          'p_duration_day': khatma.durationDay,
          'p_is_fajr': khatma.isFajr,
          'p_is_priority': khatma.isPriority,
          'p_participant_names': participantNames,
        },
      );

      if (response.isNotEmpty && response is List<dynamic>) {
        return List<Map<String, dynamic>>.from(response);
      }
      return null;

    } catch (e) {
      print('Error adding Khatma and distributing parts: $e');

      rethrow;
    }
  }
  Future<List<Map<String, dynamic>>> getKhatmaDistributionForDate(
      String khatmaId, DateTime targetDate) async {
    try {
      final response = await _supabaseClient.rpc(
        'get_khatma_distribution_for_date',
        params: {
          'p_khatma_id': khatmaId,
          'p_target_date': targetDate.toIso8601String().split('T')[0],
        },
      );

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error getting khatma distribution for date: $e');
      throw Exception('Failed to get khatma distribution for date: $e');
    }
  }

  Future<List<KhatmaPart>> fetchKhatmaParts(String khatmaId) async {
    final List<dynamic> response = await _supabaseClient
        .from('read_parts')
        .select('*, publicparticipants!participant_id(name)')
        .eq('khatma_id', khatmaId)
        .order('part_number', ascending: true);

    return response.map((json) {
      return KhatmaPart.fromJson(json as Map<String, dynamic>);
    }).toList();
  }
  Future<void> markKhatmaPartsAsReadForDate(String khatmaId, DateTime targetDate) async {
    try {
      await _supabaseClient.rpc(
        'mark_khatma_parts_as_read_for_date',
        params: {
          'p_khatma_id': khatmaId,
          'p_target_date': targetDate.toIso8601String().split('T')[0],
        },
      );
    } catch (e) {
      print('Error marking khatma parts as read: $e');
      rethrow;
    }
  }

  }