class PrayerTimesResponse {
  final Map<String, dynamic> timings;

  PrayerTimesResponse({required this.timings});

  factory PrayerTimesResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null && json['data']['timings'] != null) {
      return PrayerTimesResponse(
        timings: json['data']['timings'],
      );
    } else {
      throw Exception('Failed to parse prayer times: Missing data or timings');
    }
  }
}