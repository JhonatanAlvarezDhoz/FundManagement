import 'package:fund_management/core/services/local_storage_service.dart';
import 'package:fund_management/core/utils/time_simulator.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  /// services
  sl.registerLazySingleton(() => LocalStorageService());
  sl.registerLazySingleton(() => TimeSimulator());

  /// repository

  /// usecases

  /// bloc
}
