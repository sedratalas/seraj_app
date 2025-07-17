import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:seraj_app/widget/series.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/dependency_injection/di.dart';
import 'screen/private_khatmat/bloc/khatmat_bloc.dart';
import 'screen/private_khatmat/private_khatmat_screen.dart';
import 'screen/public_khatmat/bloc/khatmat_bloc.dart';
import 'screen/public_khatmat/public_khatmat_screen.dart';
import 'screen/zekir_session/azkar_sessions.dart';
import 'screen/zekir_session/bloc/zekir_session_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  await initDependencies();

  runApp(
    MultiBlocProvider(
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
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PublicKhatmatScreen(),
    );
  }
}