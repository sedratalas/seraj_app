
import 'package:bloc/bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../model/private_khatma_model.dart';
import '../../../model/privat_parts_model.dart';
import '../../../service/private_khatma_service.dart';
import 'khatmat_event.dart';
import 'khatmat_state.dart';

class KhatmatBloc extends Bloc<KhatmatEvent, KhatmatState> {
  final KhatmatService _khatmatService;

  KhatmatBloc({required KhatmatService khatmatService})
      : _khatmatService = khatmatService,
        super(KhatmatInitial()) {
    on<LoadKhatmat>(_onLoadKhatmat);
    on<AddKhatma>(_onAddKhatma);
    on<LoadKhatmaParts>(_onLoadKhatmaParts);
    on<UpdateKhatmaPartStatus>(_onUpdateKhatmaPartStatus);
  }

  Future<void> _onLoadKhatmat(
      KhatmatEvent event, Emitter<KhatmatState> emit) async {
    emit(LoadingKhatmat());
    try {
      final List<KhatmaModel> khatmat = await _khatmatService.fetchKhatmat();
      emit(LoadedKhatmat(khatmat));
    } catch (e) {
      emit(KhatmatError('فشل في جلب الختمات: ${e.toString()}'));
    }
  }

  Future<void> _onAddKhatma(
      AddKhatma event, Emitter<KhatmatState> emit) async {
    emit(AddingKhatma());
    try {
      await _khatmatService.addKhatmaWithParts(event.khatma);
      emit(KhatmaAdded());
      add(LoadKhatmat());
    } catch (e) {
      emit(KhatmatError('فشل في إضافة الختمة: ${e.toString()}'));
    }
  }

  Future<void> _onLoadKhatmaParts(
      LoadKhatmaParts event, Emitter<KhatmatState> emit) async {
    emit(LoadingKhatmaParts());
    try {
      final List<KhatmaPartModel> khatmaParts =
      await _khatmatService.fetchKhatmaParts(event.khatmaId);
      emit(LoadedKhatmaParts(khatmaParts: khatmaParts));
    } catch (e) {
      emit(KhatmatError('فشل في جلب أجزاء الختمة: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateKhatmaPartStatus(
      UpdateKhatmaPartStatus event, Emitter<KhatmatState> emit) async {
    emit(UpdatingKhatmaPartStatus());
    try {
      await _khatmatService.updateKhatmaPartStatus(event.khatmaPart);
      add(LoadKhatmaParts(khatmaId: event.khatmaPart.khatmaId));
      emit(KhatmaPartStatusUpdated());
    } catch (e) {
      emit(KhatmatError('فشل في تحديث حالة الجزء: ${e.toString()}'));
    }
  }
}