import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/private_khatma_model.dart';
import '../model/privat_parts_model.dart';

class KhatmatService {
  final SupabaseClient _supabaseClient;

  KhatmatService(this._supabaseClient);

  Future<List<KhatmaModel>> fetchKhatmat() async {
    final List<Map<String, dynamic>> response = await _supabaseClient
        .from('privatkhatmat')
        .select()
        .order('created_at', ascending: false);

    return response.map((map) => KhatmaModel.fromMap(map)).toList();
  }

  Future<void> addKhatmaWithParts(KhatmaModel khatma) async {
    final Map<String, dynamic> response = await _supabaseClient
        .from('privatkhatmat')
        .insert(khatma.toMap())
        .select('id')
        .single();

    final String newKhatmaId = response['id'];

    final List<Map<String, dynamic>> partsToInsert = [];
    for (int i = 1; i <= 30; i++) {
      partsToInsert.add({
        'khatma_id': newKhatmaId,
        'part_number': i,
        'is_completed': false,
      });
    }
    await _supabaseClient.from('privatkhatmaparts').insert(partsToInsert);
  }

  Future<List<KhatmaPartModel>> fetchKhatmaParts(String khatmaId) async {
    final List<Map<String, dynamic>> response = await _supabaseClient
        .from('privatkhatmaparts')
        .select()
        .eq('khatma_id', khatmaId)
        .order('part_number', ascending: true);

    return response.map((map) => KhatmaPartModel.fromMap(map)).toList();
  }

  Future<void> updateKhatmaPartStatus(KhatmaPartModel khatmaPart) async {
    await _supabaseClient
        .from('privatkhatmaparts')
        .update(khatmaPart.toMap())
        .eq('id', khatmaPart.id!);
  }
}