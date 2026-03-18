import 'package:fund_management/core/services/local_storage_service.dart';
import 'package:fund_management/core/utils/time_simulator.dart';
import 'package:fund_management/features/funds/data/datasources/funds_local_datasource.dart';
import 'package:fund_management/features/funds/data/repository/fund_repository_impl.dart';
import 'package:fund_management/features/funds/domain/repository/funds_repository.dart';
import 'package:fund_management/features/funds/domain/usecase/uc_get_funds.dart';
import 'package:fund_management/features/funds/domain/usecase/uc_subscribe_funds.dart';
import 'package:fund_management/features/funds/presentation/bloc/fund_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  /// services
  sl.registerLazySingleton(() => LocalStorageService());
  sl.registerLazySingleton(() => TimeSimulator());

  // DataSources
  sl.registerLazySingleton<FundsLocalDataSource>(
    () => FundsLocalDataSourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<FundsRepository>(() => FundsRepositoryImpl(sl()));

  // UseCases
  sl.registerLazySingleton(() => UcGetFundsUseCase(sl()));
  sl.registerLazySingleton(() => UcSubscribeFundUseCase(sl()));

  // Bloc
  sl.registerFactory(
    () => FundBloc(ucGetFundsUseCase: sl(), ucSubscribeFundUseCase: sl()),
  );
}
