import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:seraj_app/screen/home_screen/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';
import 'config.dart';
import 'core/dependency_injection/di.dart';
import 'screen/private_khatmat/bloc/khatmat_bloc.dart';
import 'screen/public_khatmat/bloc/khatmat_bloc.dart';
import 'screen/zekir_session/bloc/zekir_session_bloc.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  debugPrint('Background notification payload: ${notificationResponse.payload}');
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final khatmaIntention = inputData?['khatmaIntention'];
    final khatmaId = inputData?['khatmaId'];
    await _configureLocalNotifications();
    await flutterLocalNotificationsPlugin.show(
      khatmaId.hashCode,
      '📖 تذكير يومي بالختمة',
      'حان وقت توزيع أجزاء ختمة "$khatmaIntention" لليوم.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'khatma_reminder_channel',
          'تذكير الختمة',
          channelDescription: 'تذكير يومي لتوزيع أجزاء الختمة',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
    return Future.value(true);
  });
}

Future<void> _configureLocalNotifications() async {
  tz.initializeTimeZones();
  try {
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  } catch (_) {
    tz.setLocalLocation(tz.getLocation('Europe/Amsterdam'));
  }

  const initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    iOS: DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    ),
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
      if (notificationResponse.payload != null) {
        debugPrint('Notification payload: ${notificationResponse.payload}');
      }
    },
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _configureLocalNotifications();
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  await Permission.notification.request();
  await Permission.scheduleExactAlarm.request();
  await dotenv.load(fileName: ".env");
  Bloc.observer = MyBlocObserver();
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  await initDependencies();

  runApp(
    ProviderScope(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ZekirSessionBloc()),
          BlocProvider(create: (context) => sl<KhatmatBloc>()),
          BlocProvider(create: (context) => sl<PublicKhatmatBloc>()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

// import 'package:device_preview/device_preview.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_timezone/flutter_timezone.dart';
// import 'package:seraj_app/screen/home_screen/home_screen.dart';
// import 'package:seraj_app/screen/tasbeeh_counter.dart';
// import 'package:seraj_app/widget/series.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'config.dart';
// import 'core/dependency_injection/di.dart';
// import 'screen/private_khatmat/bloc/khatmat_bloc.dart';
// import 'screen/private_khatmat/private_khatmat_screen.dart';
// import 'screen/public_khatmat/bloc/khatmat_bloc.dart';
// import 'screen/public_khatmat/public_khatmat_screen.dart';
// import 'screen/zekir_session/azkar_sessions.dart';
// import 'screen/zekir_session/bloc/zekir_session_bloc.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
//
//
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
// @pragma('vm:entry-point')
// void notificationTapBackground(NotificationResponse notificationResponse) {
//   debugPrint('Background notification payload: ${notificationResponse.payload}');
// }
//
// Future<void> _configureLocalNotifications() async {
//   tz.initializeTimeZones();
//
//   final String timeZoneName;
//   try {
//
//     timeZoneName = await FlutterTimezone.getLocalTimezone();
//     tz.setLocalLocation(tz.getLocation(timeZoneName));
//   } catch (e) {
//
//     debugPrint('Could not get local timezone: $e');
//     tz.setLocalLocation(tz.getLocation('Europe/Amsterdam'));
//   }
//
//
//   // إعدادات الأندرويد:
//   const AndroidInitializationSettings initializationSettingsAndroid =
//   AndroidInitializationSettings('app_icon');
//
//   // إعدادات iOS:
//
//   const DarwinInitializationSettings initializationSettingsIOS =
//   DarwinInitializationSettings(
//     requestAlertPermission: true,
//     requestBadgePermission: true,
//     requestSoundPermission: true,
//   );
//
//
//   const InitializationSettings initializationSettings =
//   InitializationSettings(
//     android: initializationSettingsAndroid,
//     iOS: initializationSettingsIOS,
//   );
//
//
//   await flutterLocalNotificationsPlugin.initialize(
//     initializationSettings,
//     onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
//       if (notificationResponse.payload != null) {
//         debugPrint('Notification payload: ${notificationResponse.payload}');
//
//       }
//     },
//   );
// }
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await _configureLocalNotifications();
//   await dotenv.load(fileName: ".env");
//   Bloc.observer = MyBlocObserver();
//   await Supabase.initialize(
//     url: dotenv.env['SUPABASE_URL']!,
//     anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
//   );
//
//   await initDependencies();
//
//   runApp(
//     ProviderScope(
//       child: MultiBlocProvider(
//         providers: [
//           BlocProvider(
//             create: (context) => ZekirSessionBloc(),
//           ),
//           BlocProvider(
//             create: (context) => sl<KhatmatBloc>(),
//           ),
//           BlocProvider(
//             create: (context) => sl<PublicKhatmatBloc>(),
//           ),
//         ],
//         child: DevicePreview(
//           enabled: !kReleaseMode,
//           builder: (BuildContext context) => const MyApp(),
//         ),
//       ),
//     ),
//   );
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: HomeScreen(),
//     );
//   }
// }
/*import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:seraj_app/screen/home_screen/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config.dart';
import 'core/dependency_injection/di.dart';
import 'screen/private_khatmat/bloc/khatmat_bloc.dart';
import 'screen/public_khatmat/bloc/khatmat_bloc.dart';
import 'screen/zekir_session/bloc/zekir_session_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  debugPrint('Background notification payload: ${notificationResponse.payload}');
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> _configureLocalNotifications() async {
  tz.initializeTimeZones();

  final String timeZoneName;
  try {
    timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  } catch (e) {
    debugPrint('Could not get local timezone: $e. Defaulting to Europe/Amsterdam.');
    tz.setLocalLocation(tz.getLocation('Europe/Amsterdam'));
  }

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings initializationSettingsIOS =
  DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  const InitializationSettings initializationSettings =
  InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
      if (notificationResponse.payload != null) {
        debugPrint('Foreground notification payload: ${notificationResponse.payload}');
      }
    },
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );

  }


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _configureLocalNotifications();
  await Permission.notification.request();
  await Permission.scheduleExactAlarm.request();
  await dotenv.load(fileName: ".env");
  Bloc.observer = MyBlocObserver();
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  await initDependencies();

  runApp(
    ProviderScope(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ZekirSessionBloc(),
          ),
          BlocProvider(
            create: (context) => sl<KhatmatBloc>(),
          ),
          BlocProvider(
            create: (context) => sl<PublicKhatmatBloc>(),
          ),
        ],
        child: DevicePreview(
          enabled: !kReleaseMode,
          builder: (BuildContext context) => const MyApp(),
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}*/