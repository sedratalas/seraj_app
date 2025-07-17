
import 'package:get_it/get_it.dart';
import 'package:seraj_app/screen/public_khatmat/bloc/khatmat_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../screen/private_khatmat/bloc/khatmat_bloc.dart';
import '../../service/private_khatma_service.dart';
import '../../service/public_khatma_service.dart';


final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {

  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  sl.registerLazySingleton<KhatmatService>(
        () => KhatmatService(sl()),
  );

  sl.registerFactory<KhatmatBloc>(
        () => KhatmatBloc(khatmatService: sl()),
  );
  sl.registerLazySingleton<PublicKhatmatService>(
        () => PublicKhatmatService(sl()),
  );

  sl.registerFactory<PublicKhatmatBloc>(
        () => PublicKhatmatBloc(khatmatService: sl()),
  );
}