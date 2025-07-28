// import 'package:bloc/bloc.dart';
// import '../../../model/public_khatma_model.dart';
// import '../../../model/public_khatma_part.dart';
// import '../../../service/public_khatma_service.dart';
// import 'khatmat_event.dart';
// import 'khatmat_state.dart';
//
// class PublicKhatmatBloc extends Bloc<KhatmatEvent, KhatmatState> {
//   final PublicKhatmatService _khatmatService;
//
//   PublicKhatmatBloc({required PublicKhatmatService khatmatService})
//       : _khatmatService = khatmatService,
//         super(KhatmatInitial()) {
//     on<LoadKhatmat>(_onLoadKhatmat);
//     on<AddKhatma>(_onAddKhatma);
//     on<GetKhatmaDistributionForDate>(_onGetKhatmaDistributionForDate);
//     on<LoadKhatmaParts>(_onLoadKhatmaParts);
//     on<MarkKhatmaPartsAsRead>(_onMarkKhatmaPartsAsRead);
//   }
//
//   Future<void> _onLoadKhatmat(
//       KhatmatEvent event, Emitter<KhatmatState> emit) async {
//     emit(LoadingKhatmat());
//     try {
//       final List<KhatmaModel> khatmat = await _khatmatService.fetchKhatmat();
//       emit(LoadedKhatmat(khatmat));
//     } catch (e, stackTrace) {
//       emit(KhatmatError('فشل في جلب الختمات: ${e.toString()}'));
//       print('Error in _onLoadKhatmat: $e\n$stackTrace');
//     }
//   }
//
//   Future<void> _onAddKhatma(
//       AddKhatma event, Emitter<KhatmatState> emit) async {
//     emit(AddingKhatma());
//     try {
//       final List<Map<String, dynamic>>? distributionResult =
//       await _khatmatService.addPublicKhatmaAndDistributeParts(
//           event.khatma, event.participantNames);
//
//       emit(KhatmaAdded(distributionResult: distributionResult));
//       add(LoadKhatmat());
//     } catch (e, stackTrace) {
//       emit(KhatmatError('فشل في إضافة الختمة وتوزيع الأجزاء: ${e.toString()}'));
//       print('Error in _onAddKhatma: $e\n$stackTrace');
//     }
//   }
//
//   Future<void> _onGetKhatmaDistributionForDate(
//       GetKhatmaDistributionForDate event,
//       Emitter<KhatmatState> emit,
//       ) async {
//     emit(KhatmaDistributionLoading());
//     try {
//       final distribution = await _khatmatService.getKhatmaDistributionForDate(
//         event.khatmaId,
//         event.targetDate,
//       );
//
//       await _khatmatService.markKhatmaPartsAsReadForDate(
//         event.khatmaId,
//         event.targetDate,
//       );
//       print('KhatmatBloc: الأجزاء تم تحديدها كمقروءة داخلياً للختمة ID: ${event.khatmaId}, التاريخ: ${event.targetDate}');
//
//       emit(KhatmaDistributionLoaded(distributionResult: distribution));
//     } catch (e, stackTrace) {
//       print('KhatmatBloc: خطأ في جلب التوزيع: $e\n$stackTrace');
//       emit(KhatmatError('فشل جلب التوزيع: ${e.toString()}', sourceEvent: event));
//     }
//   }
//
//   Future<void> _onLoadKhatmaParts(LoadKhatmaParts event, Emitter<KhatmatState> emit) async {
//     emit(LoadingKhatmaParts());
//     try {
//       final List<KhatmaPart> parts = await _khatmatService.fetchKhatmaParts(event.khatmaId);
//       emit(LoadedKhatmaParts(parts));
//     } catch (e, stackTrace) {
//       emit(KhatmatError('فشل في جلب أجزاء الختمة: ${e.toString()}', sourceEvent: event));
//       print('Error in _onLoadKhatmaParts: $e\n$stackTrace');
//     }
//   }
//
//   Future<void> _onMarkKhatmaPartsAsRead(MarkKhatmaPartsAsRead event, Emitter<KhatmatState> emit) async {
//     try {
//       await _khatmatService.markKhatmaPartsAsReadForDate(event.khatmaId, event.targetDate);
//       print('Khatma parts marked as read. Reloading parts for ID: ${event.khatmaId}');
//       add(LoadKhatmaParts(khatmaId: event.khatmaId));
//     } catch (e, stackTrace) {
//       emit(KhatmatError('فشل في تحديد الأجزاء كمقروءة: ${e.toString()}', sourceEvent: event));
//       print('Error in _onMarkKhatmaPartsAsRead: $e\n$stackTrace');
//     }
//   }
// }
import 'package:bloc/bloc.dart';
import '../../../model/public_khatma_model.dart';
import '../../../model/public_khatma_part.dart';
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
    on<LoadKhatmaParts>(_onLoadKhatmaParts);
    on<MarkKhatmaPartsAsRead>(_onMarkKhatmaPartsAsRead);
  }

  Future<void> _onLoadKhatmat(
      KhatmatEvent event, Emitter<KhatmatState> emit) async {
    emit(LoadingKhatmat());
    try {
      final List<KhatmaModel> khatmat = await _khatmatService.fetchKhatmat();
      emit(LoadedKhatmat(khatmat));
    } catch (e, stackTrace) {
      emit(KhatmatError('فشل في جلب الختمات: ${e.toString()}'));
      print('Error in _onLoadKhatmat: $e\n$stackTrace');
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
    } catch (e, stackTrace) {
      emit(KhatmatError('فشل في إضافة الختمة وتوزيع الأجزاء: ${e.toString()}'));
      print('Error in _onAddKhatma: $e\n$stackTrace');
    }
  }

  Future<void> _onGetKhatmaDistributionForDate(
      GetKhatmaDistributionForDate event,
      Emitter<KhatmatState> emit,
      ) async {
    emit(KhatmaDistributionLoading());
    try {
      final distribution = await _khatmatService.getKhatmaDistributionForDate(
        event.khatmaId,
        event.targetDate,
      );

      emit(KhatmaDistributionLoaded(
        distributionResult: distribution,
        khatmaId: event.khatmaId,
        targetDate: event.targetDate,
      ));
    } catch (e, stackTrace) {
      print('KhatmatBloc: خطأ في جلب التوزيع: $e\n$stackTrace');
      emit(KhatmatError('فشل جلب التوزيع: ${e.toString()}', sourceEvent: event));
    }
  }

  Future<void> _onLoadKhatmaParts(LoadKhatmaParts event, Emitter<KhatmatState> emit) async {
    emit(LoadingKhatmaParts());
    try {
      final List<KhatmaPart> parts = await _khatmatService.fetchKhatmaParts(event.khatmaId);
      emit(LoadedKhatmaParts(parts));
    } catch (e, stackTrace) {
      emit(KhatmatError('فشل في جلب أجزاء الختمة: ${e.toString()}', sourceEvent: event));
      print('Error in _onLoadKhatmaParts: $e\n$stackTrace');
    }
  }

  Future<void> _onMarkKhatmaPartsAsRead(MarkKhatmaPartsAsRead event, Emitter<KhatmatState> emit) async {
    try {
      await _khatmatService.markKhatmaPartsAsReadForDate(event.khatmaId, event.targetDate);
      print('Khatma parts marked as read. Reloading parts for ID: ${event.khatmaId}');
      add(LoadKhatmaParts(khatmaId: event.khatmaId));
    } catch (e, stackTrace) {
      emit(KhatmatError('فشل في تحديد الأجزاء كمقروءة: ${e.toString()}', sourceEvent: event));
      print('Error in _onMarkKhatmaPartsAsRead: $e\n$stackTrace');
    }
  }
}