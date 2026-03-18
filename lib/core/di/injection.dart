import 'package:fund_management/features/funds/data/datasources/funds_remote_data_source.dart';
import 'package:fund_management/features/funds/data/datasources/funds_remote_data_source_impl.dart';
import 'package:fund_management/features/funds/data/repositories/fund_repository_impl.dart';
import 'package:fund_management/features/funds/domain/repositories/fund_repository.dart';
import 'package:fund_management/features/funds/domain/usecases/get_fund_by_id_use_case.dart';
import 'package:fund_management/features/funds/domain/usecases/get_funds_use_case.dart';
import 'package:fund_management/features/funds/presentation/bloc/funds_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  final prefs = await SharedPreferences.getInstance();

  getIt.registerLazySingleton<SharedPreferences>(() => prefs);

  getIt.registerLazySingleton<FundsRemoteDataSource>(
    () => FundsRemoteDataSourceImpl(),
  );

  getIt.registerLazySingleton<FundRepository>(
    () => FundRepositoryImpl(getIt()),
  );

  getIt.registerLazySingleton(() => GetFundsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetFundByIdUseCase(getIt()));

  getIt.registerFactory(() => FundsBloc(getFundsUseCase: getIt()));
}
