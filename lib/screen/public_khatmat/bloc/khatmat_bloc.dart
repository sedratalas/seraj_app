
import 'package:bloc/bloc.dart';
import '../../../model/public_khatma_model.dart';
import '../../../service/public_khatma_service.dart';
import 'khatmat_event.dart';
import 'khatmat_state.dart';

class PublicKhatmatBloc extends Bloc<KhatmatEvent, KhatmatState> {
  final PublicKhatmatService _khatmatService;

  PublicKhatmatBloc({required PublicKhatmatService khatmatService})
      : _khatmatService = khatmatService,
        super(KhatmatInitial()) {
    on<LoadKhatmat>(_onLoadKhatmat);
     on<AddKhatma>(_onAddKhatma);
    on<GetKhatmaDistributionForDate>(_onGetKhatmaDistributionForDate);
    // on<LoadKhatmaParts>(_onLoadKhatmaParts);
    // on<UpdateKhatmaPartStatus>(_onUpdateKhatmaPartStatus);
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
      final List<Map<String, dynamic>>? distributionResult =
      await _khatmatService.addPublicKhatmaAndDistributeParts(
          event.khatma, event.participantNames);

      emit(KhatmaAdded(distributionResult: distributionResult));
      add(LoadKhatmat());
    } catch (e) {
      emit(KhatmatError('فشل في إضافة الختمة وتوزيع الأجزاء: ${e.toString()}'));
    }
  }
  Future<void> _onGetKhatmaDistributionForDate(GetKhatmaDistributionForDate event, Emitter<KhatmatState> emit) async {
   // emit(KhatmatLoading());
    try {
      final distribution = await _khatmatService.getKhatmaDistributionForDate(
        event.khatmaId,
        event.targetDate,
      );
      emit(KhatmaDistributionLoaded(distributionResult: distribution));

    } catch (e) {
      emit(KhatmatError('فشل في جلب توزيع الأجزاء لليوم المحدد: ${e.toString()}', sourceEvent: event));
    }
  }


}