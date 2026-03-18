import 'package:fund_management/features/funds/data/datasources/funds_remote_data_source.dart';
import 'package:fund_management/features/funds/data/datasources/funds_remote_data_source_impl.dart';
import 'package:fund_management/features/funds/data/repositories/fund_repository_impl.dart';
import 'package:fund_management/features/funds/domain/repositories/fund_repository.dart';
import 'package:fund_management/features/funds/domain/usecases/get_fund_by_id_use_case.dart';
import 'package:fund_management/features/funds/domain/usecases/get_funds_use_case.dart';
import 'package:fund_management/features/funds/presentation/bloc/funds_bloc.dart';
import 'package:fund_management/features/history/data/datasources/history_local_data_source.dart';
import 'package:fund_management/features/history/data/datasources/history_local_data_source_impl.dart';
import 'package:fund_management/features/history/data/repositories/transaction_repository_impl.dart';
import 'package:fund_management/features/history/domain/repositories/transaction_repository.dart';
import 'package:fund_management/features/history/domain/usecases/get_transaction_history_use_case.dart';
import 'package:fund_management/features/history/presentation/bloc/history_bloc.dart';
import 'package:fund_management/features/portfolio/data/datasources/portfolio_local_data_source.dart';
import 'package:fund_management/features/portfolio/data/datasources/portfolio_local_data_source_impl.dart';
import 'package:fund_management/features/portfolio/data/repositories/portfolio_repository_impl.dart';
import 'package:fund_management/features/portfolio/domain/repositories/portfolio_repository.dart';
import 'package:fund_management/features/portfolio/domain/usecases/cancel_fund_subscription_use_case.dart';
import 'package:fund_management/features/portfolio/domain/usecases/get_portfolio_use_case.dart';
import 'package:fund_management/features/portfolio/domain/usecases/get_wallet_summary_use_case.dart';
import 'package:fund_management/features/portfolio/domain/usecases/subscribe_to_fund_use_case.dart';
import 'package:fund_management/features/portfolio/presentation/bloc/portfolio_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Storage
  final prefs = await SharedPreferences.getInstance();

  getIt.registerLazySingleton<SharedPreferences>(() => prefs);

  // Datasources
  getIt.registerLazySingleton<FundsRemoteDataSource>(
    () => FundsRemoteDataSourceImpl(),
  );

  getIt.registerLazySingleton<PortfolioLocalDataSource>(
    () => PortfolioLocalDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<HistoryLocalDataSource>(
    () => HistoryLocalDataSourceImpl(getIt()),
  );

  // Repositoties
  getIt.registerLazySingleton<FundRepository>(
    () => FundRepositoryImpl(getIt()),
  );

  getIt.registerLazySingleton<PortfolioRepository>(
    () => PortfolioRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(getIt()),
  );

  // UseCases
  getIt.registerLazySingleton(() => GetFundsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetFundByIdUseCase(getIt()));
  getIt.registerLazySingleton(() => GetWalletSummaryUseCase(getIt()));
  getIt.registerLazySingleton(() => GetPortfolioUseCase(getIt()));
  getIt.registerLazySingleton(
    () => SubscribeToFundUseCase(
      fundRepository: getIt(),
      portfolioRepository: getIt(),
      transactionRepository: getIt(),
    ),
  );
  getIt.registerLazySingleton(
    () => CancelFundSubscriptionUseCase(
      portfolioRepository: getIt(),
      transactionRepository: getIt(),
    ),
  );
  getIt.registerLazySingleton(() => GetTransactionHistoryUseCase(getIt()));

  // Blocs
  getIt.registerFactory(() => FundsBloc(getFundsUseCase: getIt()));
  getIt.registerFactory(
    () => HistoryBloc(getTransactionHistoryUseCase: getIt()),
  );
  getIt.registerFactory(
    () => PortfolioBloc(
      getPortfolioUseCase: getIt(),
      getWalletSummaryUseCase: getIt(),
      subscribeToFundUseCase: getIt(),
      cancelFundSubscriptionUseCase: getIt(),
      portfolioRepository: getIt(),
      transactionRepository: getIt(),
    ),
  );
}
