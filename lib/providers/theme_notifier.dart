import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../core/utils/color_manager.dart';
import '../service/prayer_time_service.dart';

const String FAJR_BACKGROUND_IMAGE = "assets/images/fajer_theme.png";
const String DEFAULT_BACKGROUND_IMAGE = "assets/images/splash (1).png";

const String DEFAULT_LEFT_FLORAL_IMAGE = "assets/images/left_floral.png";
const String DEFAULT_RIGHT_FLORAL_IMAGE = "assets/images/right_floral.png";
const String DEFAULT_MANDALA_IMAGE = "assets/images/mandala (2) 1.png";

const String FAJR_LEFT_FLORAL_IMAGE = "assets/images/fajerfloralleft.png";
const String FAJR_RIGHT_FLORAL_IMAGE = "assets/images/fajerfloralright.png";
const String FAJR_MANDALA_IMAGE = "assets/images/fajermandala.png";

class ThemeState {
  final String currentBackgroundImage;
  final String? fajrTime;
  final String? sunriseTime;
  final String? errorMessage;
  final String currentLeftFloralImage;
  final String currentRightFloralImage;
  final String currentMandalaImage;
  final Color sirajTextColor;
  final Color currentMandalaBackgroung;

  ThemeState({
    required this.currentBackgroundImage,
    this.fajrTime,
    this.sunriseTime,
    this.errorMessage,
    this.currentLeftFloralImage = DEFAULT_LEFT_FLORAL_IMAGE,
    this.currentRightFloralImage = DEFAULT_RIGHT_FLORAL_IMAGE,
    this.currentMandalaImage = DEFAULT_MANDALA_IMAGE,
    this.sirajTextColor = AppColors.darkBrown,
    this.currentMandalaBackgroung = AppColors.mandalaBack,
  });

  ThemeState copyWith({
    String? currentBackgroundImage,
    String? fajrTime,
    String? sunriseTime,
    String? errorMessage,
    String? currentLeftFloralImage,
    String? currentRightFloralImage,
    String? currentMandalaImage,
    Color? sirajTextColor,
    Color? currentMandalaBackgroung,
  }) {
    return ThemeState(
      currentBackgroundImage: currentBackgroundImage ?? this.currentBackgroundImage,
      fajrTime: fajrTime ?? this.fajrTime,
      sunriseTime: sunriseTime ?? this.sunriseTime,
      errorMessage: errorMessage ?? this.errorMessage,
      currentLeftFloralImage: currentLeftFloralImage ?? this.currentLeftFloralImage,
      currentRightFloralImage: currentRightFloralImage ?? this.currentRightFloralImage,
      currentMandalaImage: currentMandalaImage ?? this.currentMandalaImage,
      sirajTextColor: sirajTextColor ?? this.sirajTextColor,
      currentMandalaBackgroung: currentMandalaBackgroung ?? this.currentMandalaBackgroung,
    );
  }
}

class ThemeNotifier extends StateNotifier<ThemeState> {
  final PrayerTimeService _prayerTimeService;
  Timer? _timer;
  String _currentCity = "Damascus";
  String _currentCountry = "Syria";

  ThemeNotifier(this._prayerTimeService)
      : super(ThemeState(
    currentBackgroundImage: DEFAULT_BACKGROUND_IMAGE,
    currentLeftFloralImage: DEFAULT_LEFT_FLORAL_IMAGE,
    currentRightFloralImage: DEFAULT_RIGHT_FLORAL_IMAGE,
    currentMandalaImage: DEFAULT_MANDALA_IMAGE,
    sirajTextColor: AppColors.darkBrown,
    currentMandalaBackgroung: AppColors.mandalaBack,
  )) {
    _startThemeUpdater();
  }

  Future<void> _startThemeUpdater() async {
    await _fetchAndUpdatePrayerTimes();
    _checkAndUpdateTheme();

    _timer = Timer.periodic(const Duration(minutes: 1), (timer) async {
      if (DateTime.now().hour == 0 && DateTime.now().minute == 5) {
        await _fetchAndUpdatePrayerTimes();
      }
      _checkAndUpdateTheme();
    });
  }

  Future<void> _fetchAndUpdatePrayerTimes() async {
    state = state.copyWith(errorMessage: null);
    try {
      final prayerTimesResponse = await _prayerTimeService.fetchPrayerTimes(_currentCity, _currentCountry);

      if (prayerTimesResponse != null) {
        state = state.copyWith(
          fajrTime: prayerTimesResponse.timings['Fajr'],
          sunriseTime: prayerTimesResponse.timings['Sunrise'],
        );
      } else {
        state = state.copyWith(errorMessage: "فشل في جلب أوقات الصلاة من الخادم.");
      }
    } on DioException catch (e) {
      state = state.copyWith(errorMessage: "خطأ في الشبكة أثناء جلب أوقات الصلاة: ${e.message}");
    } catch (e) {
      state = state.copyWith(errorMessage: "خطأ غير متوقع أثناء جلب أوقات الصلاة: $e");
    }
  }

  void _checkAndUpdateTheme() {
    if (state.fajrTime == null || state.sunriseTime == null) {
      if (state.currentBackgroundImage != DEFAULT_BACKGROUND_IMAGE) {
        state = state.copyWith(
          currentBackgroundImage: DEFAULT_BACKGROUND_IMAGE,
          currentLeftFloralImage: DEFAULT_LEFT_FLORAL_IMAGE,
          currentRightFloralImage: DEFAULT_RIGHT_FLORAL_IMAGE,
          currentMandalaImage: DEFAULT_MANDALA_IMAGE,
          sirajTextColor: AppColors.darkBrown,
          currentMandalaBackgroung: AppColors.mandalaBack,
        );
      }
      return;
    }

    final now = DateTime.now();
    try {
      final fajrParts = state.fajrTime!.split(':');
      final sunriseParts = state.sunriseTime!.split(':');

      final fajrDateTime = DateTime(now.year, now.month, now.day,
          int.parse(fajrParts[0]), int.parse(fajrParts[1]));
      final sunriseDateTime = DateTime(now.year, now.month, now.day,
          int.parse(sunriseParts[0]), int.parse(sunriseParts[1]));

      final bool isInFajrPeriod = now.isAfter(fajrDateTime) && now.isBefore(sunriseDateTime);

      if (isInFajrPeriod) {
        if (state.currentBackgroundImage != FAJR_BACKGROUND_IMAGE) {
          state = state.copyWith(
            currentBackgroundImage: FAJR_BACKGROUND_IMAGE,
            currentLeftFloralImage: FAJR_LEFT_FLORAL_IMAGE,
            currentRightFloralImage: FAJR_RIGHT_FLORAL_IMAGE,
            currentMandalaImage: FAJR_MANDALA_IMAGE,
            sirajTextColor: Color(0xffFFC886),
            currentMandalaBackgroung: Color(0xffFACDA9),
          );
        }
      } else {
        if (state.currentBackgroundImage != DEFAULT_BACKGROUND_IMAGE) {
          state = state.copyWith(
            currentBackgroundImage: DEFAULT_BACKGROUND_IMAGE,
            currentLeftFloralImage: DEFAULT_LEFT_FLORAL_IMAGE,
            currentRightFloralImage: DEFAULT_RIGHT_FLORAL_IMAGE,
            currentMandalaImage: DEFAULT_MANDALA_IMAGE,
            sirajTextColor: AppColors.darkBrown,
            currentMandalaBackgroung: AppColors.mandalaBack,
          );
        }
      }
    } catch (e) {
      state = state.copyWith(errorMessage: "Error updating theme: $e");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final prayerTimeServiceProvider = Provider((ref) => PrayerTimeService());

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  final prayerTimeService = ref.watch(prayerTimeServiceProvider);
  return ThemeNotifier(prayerTimeService);
});