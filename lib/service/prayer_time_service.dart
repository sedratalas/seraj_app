import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';

import '../model/prayer_times_model.dart';

class PrayerTimeService {
  final Dio _dio = Dio();

  Future<PrayerTimesResponse?> fetchPrayerTimes(String city, String country) async {
    final now = DateTime.now();
    final date = "${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}";

    final url = 'https://api.aladhan.com/v1/timingsByCity/$date';

    try {
      final response = await _dio.get(
        url,
        queryParameters: {
          'city': city,
          'country': country,
          'method': 8,
        },
      );

      if (response.statusCode == 200) {
        return PrayerTimesResponse.fromJson(response.data);
      } else {
        print('Failed to load prayer times: ${response.statusCode}');
        return null;
      }
    } on DioException catch (e) {
      print('Error fetching prayer times: ${e.message}');
      if (e.response != null) {
        print('Error response data: ${e.response?.data}');
        print('Error response headers: ${e.response?.headers}');
      } else {
        print('Error request options: ${e.requestOptions}');
      }
      return null;
    } catch (e) {
      print('Unexpected error: $e');
      return null;
    }
  }

  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied.');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied, we cannot request permissions.');
      return null;
    }

    try {
      return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      print('Failed to get current location: $e');
      return null;
    }
  }
}