import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../service/prayer_time_service.dart';

const String FAJR_BACKGROUND_IMAGE = "assets/images/fajer_theme.png";
const String DEFAULT_BACKGROUND_IMAGE = "assets/images/splash (1).png";

class ThemeState {
  final String currentBackgroundImage;
  final String? fajrTime;
  final String? sunriseTime;
  final String? errorMessage;

  ThemeState({
    required this.currentBackgroundImage,
    this.fajrTime,
    this.sunriseTime,
    this.errorMessage,
  });

  ThemeState copyWith({
    String? currentBackgroundImage,
    String? fajrTime,
    String? sunriseTime,
    String? errorMessage,
  }) {
    return ThemeState(
      currentBackgroundImage: currentBackgroundImage ?? this.currentBackgroundImage,
      fajrTime: fajrTime ?? this.fajrTime,
      sunriseTime: sunriseTime ?? this.sunriseTime,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class ThemeNotifier extends StateNotifier<ThemeState> {
  final PrayerTimeService _prayerTimeService;
  Timer? _timer;
  String _currentCity = "Damascus";
  String _currentCountry = "Syria";

  ThemeNotifier(this._prayerTimeService)
      : super(ThemeState(currentBackgroundImage: DEFAULT_BACKGROUND_IMAGE)) {
    print("ThemeNotifier constructor called!");
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
        print('تم جلب أوقات الصلاة بنجاح: الفجر ${state.fajrTime}, الشروق ${state.sunriseTime}');
      } else {
        state = state.copyWith(errorMessage: "فشل في جلب أوقات الصلاة من الخادم.");
        print('فشل جلب أوقات الصلاة: prayerTimesResponse فارغ.');
      }
    } on DioException catch (e) { // إضافة معالجة DioException بشكل صريح
      state = state.copyWith(errorMessage: "خطأ في الشبكة أثناء جلب أوقات الصلاة: ${e.message}");
      print('خطأ في الشبكة أثناء جلب أوقات الصلاة: ${e.message}');
      if (e.response != null) {
        print('بيانات استجابة الخطأ: ${e.response?.data}');
      }
    } catch (e) {
      state = state.copyWith(errorMessage: "خطأ غير متوقع أثناء جلب أوقات الصلاة: $e");
      print("خطأ غير متوقع في _fetchAndUpdatePrayerTimes: $e");
    }
  }

  void _checkAndUpdateTheme() {
    if (state.fajrTime == null || state.sunriseTime == null) {
      if (state.currentBackgroundImage != DEFAULT_BACKGROUND_IMAGE) {
        state = state.copyWith(currentBackgroundImage: DEFAULT_BACKGROUND_IMAGE);
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

      final newImage = isInFajrPeriod ? FAJR_BACKGROUND_IMAGE : DEFAULT_BACKGROUND_IMAGE;

      if (state.currentBackgroundImage != newImage) {
        state = state.copyWith(currentBackgroundImage: newImage);
        print('Theme updated to: $newImage');
      }
    } catch (e) {
      print("Error parsing prayer times or updating theme: $e");
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