
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

  Future<Map<String, dynamic>> addPublicKhatmaAndDistributeParts(
      KhatmaModel khatma, List<String> participantNames) async {
    try {
      final dynamic rpcResponse = await _supabaseClient.rpc(
        'create_khatma_and_distribute_parts',
        params: {
          'p_id': khatma.id,
          'p_intention': khatma.intention,
          'p_start_date': khatma.startDate.toIso8601String().split('T')[0],
          'p_end_date': khatma.endDate.toIso8601String().split('T')[0],
          'p_duration_day': khatma.durationDay,
          'p_is_fajr': khatma.isFajr,
          'p_is_priority': khatma.isPriority,
          'p_created_at': khatma.createdAt.toIso8601String(),
          'p_participant_names': participantNames,
        },
      );

      final Map<String, dynamic> rpcResult;
      if (rpcResponse is List && rpcResponse.isNotEmpty) {
        rpcResult = rpcResponse.first as Map<String, dynamic>;
      } else if (rpcResponse is Map<String, dynamic>) {
        rpcResult = rpcResponse;
      } else {
        throw Exception('Unexpected RPC response type or empty: $rpcResponse');
      }

      final KhatmaModel createdKhatma = KhatmaModel(
        id: rpcResult['khatma_id'] as String,
        intention: rpcResult['khatma_intention'] as String,
        startDate: DateTime.parse(rpcResult['khatma_start_date'] as String),
        endDate: DateTime.parse(rpcResult['khatma_end_date'] as String),
        isFajr: rpcResult['khatma_is_fajr'] as bool,
        isPriority: rpcResult['khatma_is_priority'] as bool,
        durationDay: rpcResult['khatma_duration_day'] as num,
        createdAt: DateTime.parse(rpcResult['khatma_created_at'] as String),
      );

      final List<dynamic> distributionRaw = rpcResult['distribution_result'] as List<dynamic>;
      final List<Map<String, dynamic>> distributionResult =
      distributionRaw.map((e) => e as Map<String, dynamic>).toList();

      return {
        'khatma': createdKhatma,
        'distribution': distributionResult,
      };
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